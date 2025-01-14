class ChartData::CaseTemp < ChartData::Base
  private

  def data
    {
      labels: chart&.map { |x| x.first.to_i * 1000 },
      datasets: [
        {
          label: I18n.t('sensors.case_temp'),
          data: chart&.map(&:second),
        }.merge(style),
      ],
    }
  end

  def chart
    @chart ||=
      MinMaxChart.new(sensor: :case_temp, average: false).call(timeframe)[
        :case_temp
      ]
  end

  def style
    super.merge(
      backgroundColor: '#f87171', # bg-red-400
      # In min-max charts, show border around the **whole** bar (don't skip)
      borderSkipped: false,
    )
  end
end
