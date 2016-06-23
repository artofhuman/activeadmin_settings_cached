require 'spec_helper'

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

  let(:valid_base_settings) {
    { first_setting: 'BBB',
     second_setting: false,
     third_setting: 100,
     four_setting: 150.55,
     five_setting: 'bbb' }.with_indifferent_access
  }

  let(:valid_second_settings) {
    {second_setting: 'AAA', first_setting: true}.with_indifferent_access
  }

  let(:initial_some_settings) {
    {first_setting: 'CCC', second_setting: false}.with_indifferent_access
  }

  let(:valid_some_settings) {
    {first_setting: 'EEE', second_setting: true}.with_indifferent_access
  }

  context 'global config' do
    before do
      ActiveadminSettingsCached.configure do |config|
        config.display = {'base.first_setting' => 'string', 'base.second_setting' => 'boolean',
                          'base.third_setting' => 'number', 'base.four_setting' => 'number',
                          'base.five_setting' => 'string',
                          'second.first_setting' => 'boolean', 'second.second_setting' => 'string',
                          'some.first_setting' => 'string', 'some.second_setting' => 'boolean'}
      end
      add_setting_resource
      add_second_setting_resource
      # add_some_setting_resource
      add_all_setting_resource
    end

    context 'all setting index' do
      it 'when list' do
        visit '/admin/settings'
        check_base_setting
        check_second_setting
        check_some_setting_plain
      end

      it 'when save' do
        visit '/admin/settings'
        check_base_setting
        check_second_setting
        check_some_setting_plain
        fill_base_setting
        fill_second_setting
        fill_some_setting_plain
        submit
        fill_base_setting_check
        fill_second_setting_check
        fill_some_setting_check_plain
      end
    end
  end

  context 'with custom template_object' do
    context 'when right object' do
      before do
        template_object = ActiveadminSettingsCached::Model.new(display: {'base.first_setting' => 'string', 'base.second_setting' => 'boolean',
                                                                         'base.third_setting' => 'number', 'base.four_setting' => 'number',
                                                                         'base.five_setting' => 'string',
                                                                         'second.first_setting' => 'boolean', 'second.second_setting' => 'string'})
        add_all_setting_resource(template_object: template_object)
      end

      it do
        visit '/admin/base_settings'
        check_base_setting
      end
    end

    context 'when wrong object' do
      before do
        template_object = nil
        add_all_setting_resource(template_object: template_object)
      end

      it do
        visit '/admin/base_settings'
        check_base_setting
      end
    end
  end

  context 'per page' do
    before do
      ActiveadminSettingsCached.configure do |config|
        config.display = {}
      end
      add_setting_resource(display: {'base.first_setting' => 'string', 'base.second_setting' => 'boolean',
                                     'base.third_setting' => 'number', 'base.four_setting' => 'number',
                                     'base.five_setting' => 'string'})
      add_second_setting_resource(display: {'second.first_setting' => 'boolean', 'second.second_setting' => 'string'})
      add_some_setting_resource(display: {'some.first_setting' => 'string', 'some.second_setting' => 'boolean'})
      add_all_setting_resource(display: {'base.first_setting' => 'string', 'base.second_setting' => 'boolean',
                                         'base.third_setting' => 'number', 'base.four_setting' => 'number',
                                         'base.five_setting' => 'string',
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

    context 'some setting index' do
      it 'when list' do
        visit '/admin/some_settings'
        check_some_setting
      end

      it 'when save' do
        visit '/admin/some_settings'
        check_some_setting
        fill_some_setting
        submit
        fill_some_setting_check
      end
    end

    context 'all setting index' do
      it 'when list' do
        visit '/admin/settings'
        check_base_setting
        check_second_setting
        check_some_setting_plain
      end

      it 'when save' do
        visit '/admin/settings'
        check_base_setting
        check_second_setting
        check_some_setting_plain
        fill_base_setting
        fill_second_setting
        fill_some_setting_plain
        submit
        fill_base_setting_check
        fill_second_setting_check
        fill_some_setting_check_plain
      end
    end
  end

  def check_some_setting_plain
    expect(page).to have_selector("input[value='#{Setting['some'].with_indifferent_access}']")
  end

  def check_some_setting
    expect(page).to have_selector("input[value='#{Setting['some']['first_setting']}']")
  end

  def check_base_setting
    expect(page).to have_selector("input[value='#{Setting['base.first_setting']}']")
  end

  def check_second_setting
    expect(page).to have_selector("input[value='#{Setting['second.second_setting']}']")
  end

  def fill_base_setting_plain
    fill_in('settings_base', with: valid_base_settings)
  end

  def fill_base_setting
    fill_in('settings_base.first_setting', with: valid_base_settings[:first_setting])
    uncheck('settings_base.second_setting')
    fill_in('settings_base.third_setting', with: valid_base_settings[:third_setting])
    fill_in('settings_base.four_setting', with: valid_base_settings[:four_setting])
    fill_in('settings_base.five_setting', with: valid_base_settings[:five_setting])
  end

  def fill_some_setting_plain
    fill_in('settings_some', with: valid_some_settings)
  end

  def fill_some_setting
    fill_in('settings_some.first_setting', with: valid_some_settings[:first_setting])
    check('settings_some.second_setting')
  end

  def fill_second_setting
    fill_in('settings_second.second_setting', with: valid_second_settings[:second_setting])
    check('settings_second.first_setting')
  end

  def fill_base_setting_check
    expect(Setting['base.first_setting']).to eq valid_base_settings[:first_setting]
    expect(Setting['base.second_setting']).to eq valid_base_settings[:second_setting]
    expect(Setting['base.third_setting']).to eq valid_base_settings[:third_setting]
    expect(Setting['base.four_setting']).to eq valid_base_settings[:four_setting]
    expect(Setting['base.five_setting']).to eq valid_base_settings[:five_setting].to_sym
  end

  def fill_some_setting_check_plain
    expect(Setting.some.with_indifferent_access).to eq(initial_some_settings)
  end

  def fill_some_setting_check
    expect(Setting['some']['second_setting']).to eq valid_some_settings[:second_setting]
    expect(Setting['some']['first_setting']).to eq valid_some_settings[:first_setting]
  end

  def fill_second_setting_check
    expect(Setting['second.second_setting']).to eq valid_second_settings[:second_setting]
    expect(Setting['second.first_setting']).to eq valid_second_settings[:first_setting]
  end

  def submit
    click_on('Save Settings')
  end
end
