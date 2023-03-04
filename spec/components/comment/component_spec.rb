describe Comment::Component, type: :component do
  subject(:component) do
    described_class.new calculator:, field: 'inverter_power', timeframe:
  end

  let(:timeframe) { Timeframe.new(date) }
  let(:sunset) { nil }

  let(:calculator) do
    double(Calculator::Range, forecast_deviation:, watt: 1000)
  end

  before do
    allow(Sunset).to receive(:new).and_return(sunset)

    render_inline(component)
  end

  context 'when timeframe is in the past' do
    let(:date) { Date.yesterday.to_s }

    context 'when deviation is zero' do
      let(:forecast_deviation) { 0 }

      it 'comments correctly' do
        expect(page).to have_text I18n.t('forecast.exactly')
      end
    end

    context 'when deviation is positive' do
      let(:forecast_deviation) { 10 }

      it 'comments correctly' do
        expect(page).to have_text I18n.t(
                    'forecast.better_html',
                    percent: '10 %',
                  )
      end
    end

    context 'when deviation is negative' do
      let(:forecast_deviation) { -10 }

      it 'comments correctly' do
        expect(page).to have_text I18n.t('forecast.worse_html', percent: '10 %')
      end
    end
  end

  context 'when timeframe is today, before sunset' do
    let(:date) { Date.current.to_s }
    let(:sunset) { instance_double(Sunset, time: 5.minutes.since) }

    context 'when deviation is negative' do
      let(:forecast_deviation) { -10 }

      it 'comments correctly' do
        expect(page).to have_text I18n.t('forecast.expect_html', value: '1 kWh')
      end
    end
  end

  context 'when timeframe is today, after sunset' do
    let(:date) { Date.current.to_s }
    let(:sunset) { instance_double(Sunset, time: 5.minutes.ago) }

    context 'when deviation is negative' do
      let(:forecast_deviation) { -10 }

      it 'comments correctly' do
        expect(page).to have_text I18n.t('forecast.worse_html', percent: '10 %')
      end
    end
  end
end
