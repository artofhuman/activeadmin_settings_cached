# frozen_string_literal: true

RSpec.describe ActiveadminSettingsCached::Model do
  include ActiveModel::Lint::Tests

  ActiveModel::Lint::Tests.public_instance_methods.map{|m| m.to_s}.grep(/^test/).each do |m|
    example m.gsub('_',' ') do
      send m
    end
  end

  before do
    ActiveadminSettingsCached.config.display = {}
  end

  subject(:object) { described_class.new(options) }

  let(:options) { { model_name: 'Setting', scope: :base, display: { 'title' => 'text' } } }

  context '#attributes' do
    it 'set options' do
      expect(object.attributes).to eq({
                                        scope: :base,
                                        model_name: Setting,
                                        display: { 'title' => 'text' }
                                      })
    end

    context 'without options' do
      let(:options) { {} }

      it 'set default options' do
        expect(object.attributes).to eq({
                                          scope: nil,
                                          model_name: Setting,
                                          display: {}
                                        })
      end
    end
  end

  context '#keys' do
    it 'returns editable keys of scope' do
      expect(object.keys).to eq %w[title captcha_enabled user_limit tax_rate default_locale]
    end

    context 'with several scopes' do
      let(:options) { { scope: %i[base second] } }

      it { expect(object.keys).to include('title', 'admin_emails') }
      it { expect(object.keys).not_to include('app_name', 'secret') }
    end

    context 'without scope' do
      let(:options) { {} }

      it { expect(object.keys).to include('app_name', 'title', 'admin_emails') }
      it { expect(object.keys).not_to include('secret') }
    end
  end

  context '#fields_by_scope' do
    let(:options) { {} }

    it 'groups fields' do
      expect(object.fields_by_scope.keys).to eq [nil, :base, :second]
    end
  end

  context '#field_options' do
    let(:options) { {} }

    it 'with string element' do
      expect(object.field_options('app_name')).to eq(as: :string, label: false,
                                                     input_html: { value: 'AAA', placeholder: 'AAA' })
    end

    it 'with number element' do
      expect(object.field_options('user_limit')).to eq(as: :number, label: false,
                                                       input_html: { value: '5', placeholder: '5' })
    end

    it 'with boolean element' do
      expect(object.field_options('captcha_enabled')).to eq(as: :boolean, label: '',
                                                            input_html: { checked: true },
                                                            checked_value: 'true', unchecked_value: 'false')
    end

    it 'with select element' do
      expect(object.field_options('default_locale')).to eq(as: :select, label: false, collection: %w[en de ru],
                                                           selected: 'en', include_blank: false,
                                                           hint: 'Interface language')
    end

    it 'with array element' do
      expect(object.field_options('admin_emails')).to eq(as: :text, label: false,
                                                         input_html: { value: "a@example.com\nb@example.com",
                                                                       placeholder: "a@example.com\nb@example.com",
                                                                       rows: 5 })
    end

    it 'with hash element' do
      expect(object.field_options('notification_options')[:input_html][:value]).to eq("send_all: true\n")
    end

    context 'with display option' do
      let(:options) { { display: { title: :text } } }

      it { expect(object.field_options('title')[:as]).to eq :text }
    end
  end

  context '#changed?' do
    let(:options) { {} }

    it { expect(object.changed?('user_limit', '5')).to eq false }
    it { expect(object.changed?('user_limit', '6')).to eq true }
    it { expect(object.changed?('captcha_enabled', 'true')).to eq false }
    it { expect(object.changed?('admin_emails', "a@example.com\r\nb@example.com\r\n")).to eq false }
  end

  context '#save' do
    it 'saves value' do
      object.save('user_limit', '10')
      expect(Setting.user_limit).to eq 10
    end
  end

  def model
    subject
  end
end
