# frozen_string_literal: true

RSpec.describe 'settings', type: :feature do
  before do
    ActiveadminSettingsCached.config.display = {}
  end

  shared_examples_for 'render input with value' do |input_value|
    it 'has input with value' do
      expect(page).to have_selector("input[value='#{input_value}']")
    end
  end

  context 'all settings page' do
    before do
      add_all_setting_resource
      visit '/admin/settings'
    end

    it_behaves_like 'render input with value', 'AAA'
    it_behaves_like 'render input with value', 'BBB'

    it 'groups fields by scope' do
      expect(page).to have_selector('th', text: 'Base')
      expect(page).to have_selector('th', text: 'Second')
    end

    it 'hides readonly fields' do
      expect(page).not_to have_field('settings_secret')
    end

    it 'renders field help text' do
      expect(page).to have_content('Interface language')
    end

    it 'renders array and hash values' do
      expect(find_field('settings_admin_emails').value.strip).to eq("a@example.com\nb@example.com")
      expect(find_field('settings_notification_options').value.strip).to eq('send_all: true')
    end

    it 'saves settings to db' do
      fill_in('settings_app_name', with: 'App')
      fill_in('settings_title', with: 'First')
      uncheck('settings_captcha_enabled')
      fill_in('settings_user_limit', with: '100')
      fill_in('settings_tax_rate', with: '50.5')
      select('de', from: 'settings_default_locale')
      fill_in('settings_admin_emails', with: "x@example.com\ny@example.com")
      fill_in('settings_notification_options', with: "send_all: false\nlogging: true")

      submit

      expect(page).to have_content('Settings was successfully updated.')
      expect(Setting.app_name).to eq 'App'
      expect(Setting.title).to eq 'First'
      expect(Setting.captcha_enabled).to eq false
      expect(Setting.user_limit).to eq 100
      expect(Setting.tax_rate).to eq 50.5
      expect(Setting.default_locale).to eq 'de'
      expect(Setting.admin_emails).to eq %w[x@example.com y@example.com]
      expect(Setting.notification_options).to eq('send_all' => false, 'logging' => true)
    end

    it 'does not persist unchanged values' do
      fill_in('settings_title', with: 'First')

      submit

      expect(Setting.pluck(:var)).to eq %w[title]
    end

    it 'shows validation errors' do
      fill_in('settings_title', with: 'A' * 11)
      fill_in('settings_app_name', with: 'App')

      submit

      expect(page).to have_content('Settings were not saved: Title is too long')
      expect(Setting.title).to eq 'BBB'
      expect(Setting.app_name).to eq 'App'
    end
  end

  context 'when settings on different pages' do
    before do
      add_base_setting_resource
      add_second_setting_resource
    end

    context 'base settings page' do
      before { visit '/admin/base_settings' }

      it_behaves_like 'render input with value', 'BBB'

      it 'shows only base fields' do
        expect(page).to have_field('settings_title')
        expect(page).not_to have_field('settings_app_name')
        expect(page).not_to have_field('settings_admin_emails')
      end

      it 'saves settings to db' do
        fill_in('settings_title', with: 'Base')
        check('settings_captcha_enabled')
        submit

        expect(Setting.title).to eq 'Base'
        expect(Setting.captcha_enabled).to eq true
      end
    end

    context 'second settings page' do
      before { visit '/admin/second_settings' }

      it 'shows only second fields' do
        expect(page).to have_field('settings_admin_emails')
        expect(page).not_to have_field('settings_title')
      end
    end
  end

  context 'with display options' do
    before do
      add_all_setting_resource(display: { app_name: :text })
      visit '/admin/settings'
    end

    it 'uses display input type' do
      expect(page).to have_selector('textarea#settings_app_name')
    end
  end

  context 'with custom template_object' do
    context 'when right object' do
      before do
        add_all_setting_resource(template_object: ActiveadminSettingsCached::Model.new(scope: :base))
        visit '/admin/settings'
      end

      it_behaves_like 'render input with value', 'BBB'

      it { expect(page).not_to have_field('settings_app_name') }
    end

    context 'when wrong object' do
      before do
        add_all_setting_resource(template_object: nil)
        visit '/admin/settings'
      end

      it_behaves_like 'render input with value', 'AAA'
    end
  end

  describe 'with after_save' do
    context 'when submitted' do
      before do
        after_save = -> {}
        expect(after_save).to receive(:call).and_call_original

        add_base_setting_resource(after_save: after_save)
        visit '/admin/base_settings'
        submit
      end

      it_behaves_like 'render input with value', 'BBB'
    end

    context 'when only open' do
      before do
        after_save = -> {}
        expect(after_save).not_to receive(:call)

        add_base_setting_resource(after_save: after_save)
        visit '/admin/base_settings'
      end

      it_behaves_like 'render input with value', 'BBB'
    end

    context 'when wrong object' do
      before do
        add_base_setting_resource(after_save: 'some')
        visit '/admin/base_settings'
        submit
      end

      it_behaves_like 'render input with value', 'BBB'
    end
  end

  def submit
    click_on('Save Settings')
  end
end
