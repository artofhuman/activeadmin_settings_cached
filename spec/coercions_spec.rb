# frozen_string_literal: true

RSpec.describe ActiveadminSettingsCached::Coercions do
  let(:display) do
    Hash[
      'base.first_setting'    => 'string',
      'base.second_setting'   => 'boolean',
      'base.third_setting'    => 'number',
      'base.four_setting'     => 'number',
      'second.first_setting'  => 'boolean',
      'second.second_setting' => 'string'
    ].with_indifferent_access
  end

  let(:defaults) do
    Hash[
      'base.first_setting'    => 'AAA',
      'base.second_setting'   => true,
      'base.third_setting'    => 5,
      'base.four_setting'     => 5.5,
      'base.five_setting'     => :aaa,
      'second.first_setting'  => false,
      'second.second_setting' => 'BBB',
      'some'                  => Hash.new
    ].with_indifferent_access
  end

  let(:right_params) do
    ActionController::Parameters.new(
      Hash[
        'base.first_setting'    => 'BBB',
        'base.second_setting'   => 'false',
        'base.third_setting'    => '155',
        'base.four_setting'     => '55.5',
        'base.five_setting'     => 'bbb',
        'second.first_setting'  => 'true',
        'second.second_setting' => 'AAA'
      ]
    )
  end

  let(:wrong_params) do
    ActionController::Parameters.new(
      Hash['base.second_setting'  => 'hjgj',
           'base.third_setting'   => 'fhfh',
           'base.four_setting'    => 'gjfhg',
           'second.first_setting' => 'ggf',
           'some'                 => Hash.new
    ])
  end

  let(:no_params) { ActionController::Parameters.new(Hash[]) }

  subject(:coercions) do
    ActiveadminSettingsCached::Coercions.new(defaults, display)
  end

  it 'when good params' do
    expect { |b| coercions.cast_params(right_params, &b) }
      .to yield_successive_args(['base.first_setting', 'BBB'],
                                ['base.second_setting', false],
                                ['base.third_setting', 155],
                                ['base.four_setting', 55.5],
                                ['base.five_setting', :bbb],
                                ['second.first_setting', true],
                                ['second.second_setting', 'AAA'])
  end

  it 'when wrong params' do
    expect { |b| coercions.cast_params(wrong_params, &b) }
      .to yield_successive_args(['base.second_setting', false],
                                ['base.third_setting', 0],
                                ['base.four_setting', 0.0],
                                ['second.first_setting', false])
  end

  it 'when no params' do
    expect { |b| coercions.cast_params(no_params, &b) }.not_to yield_control
  end
end
