require 'spec_helper'

RSpec.describe 'settings', type: :feature, js: true do
  before do
    Setting.defaults['base.first_setting'] = 'AAA'
    Setting.defaults['base.second_setting'] = true
    Setting.defaults['base.third_setting'] = 5
    Setting.defaults['base.four_setting'] = 5.50
    Setting.defaults['base.five_setting'] = :aaa
    Setting.defaults['second.first_setting'] = false
    Setting.defaults['second.second_setting'] = 'BBB'
    Setting['base.first_setting'] = 'AAA'
    Setting['base.second_setting'] = true
    Setting['second.first_setting'] = false
    Setting['second.second_setting'] = 'BBB'
  end

  context 'global config' do
    before do
      ActiveadminSettingsCached.configure do |config|
        config.display = {'base.first_setting' => 'string', 'base.second_setting' => 'boolean',
                          'base.third_setting' => 'number', 'base.four_setting' => 'number',
                          'second.first_setting' => 'boolean', 'second.second_setting' => 'string'}
      end
      add_setting_resource
      add_second_setting_resource
      add_all_setting_resource
    end

    context 'all setting index' do
      it 'when list' do
        visit '/admin/settings'
        check_base_setting
        check_second_setting
      end

      it 'when save' do
        visit '/admin/settings'
        check_base_setting
        check_second_setting
        fill_base_setting
        fill_second_setting
        submit
        fill_base_setting_check
        fill_second_setting_check
      end
    end
  end

  context 'per page' do
    before do
      ActiveadminSettingsCached.configure do |config|
        config.display = {}
      end
      add_setting_resource(display: {'base.first_setting' => 'string', 'base.second_setting' => 'boolean',
                                     'base.third_setting' => 'number', 'base.four_setting' => 'number'})
      add_second_setting_resource(display: {'second.first_setting' => 'boolean', 'second.second_setting' => 'string'})
      add_all_setting_resource(display: {'base.first_setting' => 'string', 'base.second_setting' => 'boolean',
                                         'base.third_setting' => 'number', 'base.four_setting' => 'number',
                                         'second.first_setting' => 'boolean', 'second.second_setting' => 'string'})
    end

    context 'setting index' do
      it 'when list' do
        visit '/admin/base_settings'
        check_base_setting
      end

      it 'when save' do
        visit '/admin/base_settings'
        check_base_setting
        fill_base_setting
        submit
        fill_base_setting_check
      end
    end

    context 'second setting index' do
      it 'when list' do
        visit '/admin/second_settings'
        check_second_setting
      end

      it 'when save' do
        visit '/admin/second_settings'
        check_second_setting
        fill_second_setting
        submit
        fill_second_setting_check
      end
    end

    context 'all setting index' do
      it 'when list' do
        visit '/admin/settings'
        check_base_setting
        check_second_setting
      end

      it 'when save' do
        visit '/admin/settings'
        check_base_setting
        check_second_setting
        fill_base_setting
        fill_second_setting
        submit
        fill_base_setting_check
        fill_second_setting_check
      end
    end
  end

  def check_base_setting
    expect(page).to have_selector("input[value='#{Setting['base.first_setting']}']")
  end

  def check_second_setting
    expect(page).to have_selector("input[value='#{Setting['second.second_setting']}']")
  end

  def fill_base_setting
    fill_in('settings_base.first_setting', with: 'BBB')
    uncheck('settings_base.second_setting')
    fill_in('settings_base.third_setting', with: 100)
    fill_in('settings_base.four_setting', with: 150.55)
    fill_in('settings_base.five_setting', with: 'bbb')

  end

  def fill_second_setting
    fill_in('settings_second.second_setting', with: 'AAA')
    check('settings_second.first_setting')
  end

  def fill_base_setting_check
    expect(Setting['base.first_setting']).to eq 'BBB'
    expect(Setting['base.second_setting']).to eq false
    expect(Setting['base.third_setting']).to eq 100
    expect(Setting['base.four_setting']).to eq 150.55
    expect(Setting['base.five_setting']).to eq :bbb
  end

  def fill_second_setting_check
    expect(Setting['second.second_setting']).to eq 'AAA'
    expect(Setting['second.first_setting']).to eq true
  end

  def submit
    click_on('Save Settings')
  end
end
