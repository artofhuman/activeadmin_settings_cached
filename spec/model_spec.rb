RSpec.describe ActiveadminSettingsCached::Model do
  include ActiveModel::Lint::Tests

  ActiveModel::Lint::Tests.public_instance_methods.map{|m| m.to_s}.grep(/^test/).each do |m|
    example m.gsub('_',' ') do
      send m
    end
  end

  before(:all) do
    Setting.merge!('some', {
      'first_setting' => 'CCC',
      'second_setting' => true
    })
  end

  let(:all_options) do
    {
      model_name: 'Setting',
      starting_with: 'base.',
      key: nil,
      display: {'base.first_setting' => 'string', 'base.second_setting' => 'boolean'}
    }
  end

  let(:key_options) do
    {
      model_name: 'Setting',
      starting_with: nil,
      key: 'some',
      display: {'some.first_setting' => 'string', 'base.second_setting' => 'boolean'}
    }
  end

  let(:no_options) do
    {}
  end

  context '#attributes' do
    before do
      ActiveadminSettingsCached.config.display = {}
    end

    it 'set options' do
      object = described_class.new(all_options)
      expect(object.attributes).to eq({
                                         starting_with: all_options[:starting_with],
                                         key: nil,
                                         model_name: Setting,
                                         display: all_options[:display]
                                       })
    end

    it 'set default options' do
      object = described_class.new(no_options)
      expect(object.attributes).to eq({
                                         starting_with: nil,
                                         key: nil,
                                         model_name: Setting,
                                         display: {}
                                       })
    end

    it 'set key options' do
      object = described_class.new(key_options)
      expect(object.attributes).to eq({
                                         starting_with: nil,
                                         key: key_options[:key],
                                         model_name: Setting,
                                         display: key_options[:display]
                                       })
    end
  end

  context '#field_name' do
    it 'with keyed name' do
      object = described_class.new(key_options)
      expect(object.field_name('first_setting')).to eq('some.first_setting')
    end

    it 'with normal name' do
      object = described_class.new(all_options)
      expect(object.field_name('base.first_setting')).to eq('base.first_setting')
    end
  end

  context '#field_options' do
    it 'with default element' do
      object = described_class.new(all_options)
      expect(object.field_options('base.first_setting', 'base.first_setting')).to eq({as: 'string',
                                                                label: false,
                                                                input_html: {value: 'AAA', placeholder: 'AAA'}
                                                               })
    end

    it 'with keyed element' do
      object = described_class.new(key_options)
      expect(object.field_options('some.first_setting', 'first_setting')).to eq({as: 'string',
                                                                label: false,
                                                                input_html: {value: 'CCC', placeholder: 'AAA'}
                                                               })
    end

    it 'with array element' do
      object = described_class.new(all_options.merge({display: {'base.first_setting' => 'string',
                                                                'base.second_setting' => 'boolean',
                                                                'base.six_setting' => 'array'}}))
      expect(object.field_options('base.six_setting', 'base.six_setting')).to eq({as: 'array',
                                                              label: false,
                                                              collection: %w(a b),
                                                              selected: %w(a b)
                                                             })
    end

    it 'with boolean element' do
      object = described_class.new(all_options)
      expect(object.field_options('base.second_setting', 'base.second_setting')).to eq({as: 'boolean',
                                                                 label: '',
                                                                 input_html: {checked: true},
                                                                 checked_value: 'true',
                                                                 unchecked_value: 'false'
                                                                })
    end
  end

  context '#settings' do
    it 'normal settings' do
      object = described_class.new(all_options)
      expect(object.settings).to eq(Setting.get_all('base.'))
    end

    it 'settings by key' do
      object = described_class.new(key_options)
      expect(object.settings).to eq(Setting['some'])
    end
  end

  context '#save' do
    it 'normal settings' do
      object = described_class.new(all_options)
      object.save('base.first_setting', 'DDD')
      expect(Setting['base.first_setting']).to eq('DDD')
    end

    it 'settings by key' do
      object = described_class.new(key_options)
      object.save('some.first_setting', 'LLL')
      expect(Setting['some']['first_setting']).to eq('LLL')
    end
  end

  context '#defaults' do
    it 'normal defaults' do
      object = described_class.new(all_options)
      expect(object.defaults).to eq(RailsSettings::Default)
    end

    it 'old defaults' do
      allow(Setting).to receive(:defaults).and_return(RailsSettings::Default.instance)
      object = described_class.new(all_options)
      expect(object.defaults).to be_an_instance_of(RailsSettings::Default)
    end
  end

  context '#defaults_keys' do
    it 'normal defaults keys' do
      object = described_class.new(all_options)
      expect(object.defaults_keys).to eq(RailsSettings::Default.instance.keys)
    end
  end

  def model
    subject
  end
end
