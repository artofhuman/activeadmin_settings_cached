RSpec.describe 'settings', type: :feature, js: true do
  before do
    Setting['some'] = {
      'first_setting' => 'CCC',
      'second_setting' => false
    }
    Setting['base.first_setting'] = 'AAA'
    Setting['base.second_setting'] = true
    Setting['second.first_setting'] = false
    Setting['second.second_setting'] = 'BBB'
  end

  let(:initial_some_settings) do
    {
      first_setting: 'CCC',
      second_setting: false
    }.with_indifferent_access
  end

  shared_examples_for 'render input with value' do |input_value|
    it 'has input with value' do
      expect(page).to have_selector("input[value='#{input_value}']")
    end
  end

  shared_examples_for 'fill and save base settings to db' do
    it 'saves base settings to db' do
      fill_in('settings_base.first_setting', with: 'First')
      uncheck('settings_base.second_setting')
      fill_in('settings_base.third_setting', with: '100')
      fill_in('settings_base.four_setting', with: '50.5')
      fill_in('settings_base.five_setting', with: 'five')

      submit

      expect(Setting['base.first_setting']).to eq 'First'
      expect(Setting['base.second_setting']).to eq false
      expect(Setting['base.third_setting']).to eq 100
      expect(Setting['base.four_setting']).to eq 50.5
      expect(Setting['base.five_setting']).to eq :five
    end
  end

  shared_examples_for 'fill and save second settings to db' do
    it 'saves settings to db' do
      fill_in('settings_second.second_setting', with: 'Awesome second')
      check('settings_second.first_setting')

      submit

      expect(Setting['second.second_setting']).to eq 'Awesome second'
      expect(Setting['second.first_setting']).to eq true
      expect(Setting.some.with_indifferent_access).to eq(initial_some_settings)
    end
  end

  shared_examples_for 'fill and save some settings to db' do
    it 'save some settings to db' do
      fill_in('settings_some.first_setting', with: 'Awesome value')
      check('settings_some.second_setting')

      submit

      expect(Setting['some']['first_setting']).to eq 'Awesome value'
      expect(Setting['some']['second_setting']).to eq true
    end
  end

  context 'global config' do
    before do
      ActiveadminSettingsCached.configure do |config|
        config.display = {
          'base.first_setting'    => 'string',
          'base.second_setting'   => 'boolean',
          'base.third_setting'    => 'number',
          'base.four_setting'     => 'number',
          'base.five_setting'     => 'string',
          'second.first_setting'  => 'boolean',
          'second.second_setting' => 'string',
          'some.first_setting'    => 'string',
          'some.second_setting'   => 'boolean'
        }
      end

      add_setting_resource
      add_second_setting_resource
      add_some_setting_resource
      add_all_setting_resource
    end

    context 'all setting index' do
      before { visit '/admin/settings' }

      it_behaves_like 'render input with value', 'AAA'
      it_behaves_like 'render input with value', 'BBB'

      # TODO: fixme
      # it_behaves_like 'render input with value', Setting['some'].with_indifferent_access
      it_behaves_like 'fill and save base settings to db'
      it_behaves_like 'fill and save second settings to db'
    end
  end

  context 'with custom template_object' do
    context 'when right object' do
      before do
        display_settings = {
          'base.first_setting'    => 'string',
          'base.second_setting'   => 'boolean',
          'base.third_setting'    => 'number',
          'base.four_setting'     => 'number',
          'base.five_setting'     => 'string',
          'second.first_setting'  => 'boolean',
          'second.second_setting' => 'string'
        }

        add_all_setting_resource(
          template_object: ActiveadminSettingsCached::Model.new(display: display_settings)
        )

        visit '/admin/base_settings'
      end

      it_behaves_like 'render input with value', 'AAA'
    end

    context 'when wrong object' do
      before do
        add_all_setting_resource(template_object: nil)

        visit '/admin/base_settings'
      end

      it_behaves_like 'render input with value', 'AAA'
    end
  end

  describe 'with after_save' do
    context 'when right object' do
      before do
        after_save = ->() {}
        display_settings = {
          'base.first_setting'    => 'string',
          'base.second_setting'   => 'boolean',
          'base.third_setting'    => 'number',
          'base.four_setting'     => 'number',
          'base.five_setting'     => 'string',
          'second.first_setting'  => 'boolean',
          'second.second_setting' => 'string'
        }

        expect(after_save).to receive(:call).and_call_original

        add_some_setting_resource(
          template_object: ActiveadminSettingsCached::Model.new(display: display_settings),
          after_save: after_save
        )

        visit '/admin/some_settings'

        submit
      end

      it_behaves_like 'render input with value', 'AAA'
    end

    context 'when only open' do
      before do
        after_save = ->() {}

        expect(after_save).not_to receive(:call)

        add_some_setting_resource(template_object: nil,
                                  after_save: after_save)

        visit '/admin/some_settings'
      end

      it_behaves_like 'render input with value', 'CCC'
    end

    context 'when wrong object' do
      before do
        add_some_setting_resource(template_object: nil,
                                  after_save: 'some')

        visit '/admin/some_settings'
      end

      it_behaves_like 'render input with value', 'CCC'
    end
  end

  context 'when settings on different pages' do
    before do
      ActiveadminSettingsCached.configure do |config|
        config.display = {}
      end

      add_setting_resource(
        display: {
          'base.first_setting'  => 'string',
          'base.second_setting' => 'boolean',
          'base.third_setting'  => 'number',
          'base.four_setting'   => 'number',
          'base.five_setting'   => 'string'
        }
      )

      add_second_setting_resource(
        display: {
          'second.first_setting'  => 'boolean',
          'second.second_setting' => 'string'
        }
      )

      add_some_setting_resource(
        display: {
          'some.first_setting'  => 'string',
          'some.second_setting' => 'boolean'
        }
      )

      add_all_setting_resource(
        display: {
          'base.first_setting'    => 'string',
          'base.second_setting'   => 'boolean',
          'base.third_setting'    => 'number',
          'base.four_setting'     => 'number',
          'base.five_setting'     => 'string',
          'second.first_setting'  => 'boolean',
          'second.second_setting' => 'string'
        }
      )
    end

    context 'base settings page' do
      before { visit '/admin/base_settings' }

      it_behaves_like 'render input with value', 'AAA'
      it_behaves_like 'fill and save base settings to db'
    end

    context 'second setting page' do
      before { visit '/admin/second_settings' }

      it_behaves_like 'render input with value', 'BBB'
      it_behaves_like 'fill and save second settings to db'
    end

    context 'some setting index' do
      before { visit '/admin/some_settings' }

      it_behaves_like 'render input with value', 'CCC'
      it_behaves_like 'fill and save some settings to db'
    end

    context 'all setting index' do
      before { visit '/admin/settings' }

      it_behaves_like 'render input with value', 'AAA'
      it_behaves_like 'render input with value', 'BBB'
      # FIXME
      #it_behaves_like 'render input with value', Setting['some'].with_indifferent_access

      it_behaves_like 'fill and save base settings to db'
      it_behaves_like 'fill and save second settings to db'
      it { expect(Setting.some.with_indifferent_access).to eq(initial_some_settings) }
    end
  end

  def submit
    click_on('Save Settings')
  end
end
