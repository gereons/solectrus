class FluxChart < FluxBase
  def now
    chart_single start: '-15m', window: '5s'
  end

  def day(start)
    chart_single start: start.iso8601, stop: start.end_of_day.iso8601, window: '5m'
  end

  def week(start)
    chart_sum start: start.iso8601, stop: start.end_of_week.iso8601, window: '1d'
  end

  def month(start)
    chart_sum start: start.iso8601, stop: start.end_of_month.iso8601, window: '1d'
  end

  def year(start)
    chart_sum start: start.iso8601, stop: start.end_of_year.iso8601, window: '1mo'
  end

  def all(start)
    chart_sum start: start.iso8601, window: '1y'
  end

  private

  def chart_single(start:, window:, stop: nil)
    raw = query <<-QUERY
      #{from_bucket}
      |> #{range(start: start, stop: stop)}
      |> #{measurement_filter}
      |> #{fields_filter}
      |> aggregateWindow(every: #{window}, fn: mean)
      #{stop.nil? && '|> fill(usePrevious: true)'}
    QUERY

    to_array(raw)
  end

  def chart_sum(start:, window:, stop: nil)
    raw = query <<-QUERY
      #{from_bucket}
      |> #{range(start: start, stop: stop)}
      |> #{measurement_filter}
      |> #{fields_filter}
      |> aggregateWindow(every: 1h, fn: mean)
      |> aggregateWindow(every: #{window}, fn: sum)
    QUERY

    to_array(raw)
  end

  def to_array(raw)
    # TODO: Get all fields, not only the first one

    result = []
    if (table = raw.values[0])
      table.records.each_with_index do |record, index|
        # InfluxDB returns data one-off
        next_record = raw.values[0].records[index + 1]
        next unless next_record

        time = Time.zone.parse(record.values['_time'] || '')
        value = case record.values['_field']
                when /power/
                  # Fields with "power" in the name are given in W, so change them to kW
                  (next_record.values['_value'].to_f / 1_000).round(3)
                else
                  next_record.values['_value'].to_f
        end

        result << [ time, value ]
      end
    end
    result
  end
end
