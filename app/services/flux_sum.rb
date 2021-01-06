class FluxSum < FluxBase
  def now
    last('-5m')
  end

  def day
    sum start: Time.current.beginning_of_day.iso8601, stop: Time.current.end_of_day.iso8601
  end

  def week
    sum start: Time.current.beginning_of_week.iso8601, stop: Time.current.end_of_week.iso8601
  end

  def month
    sum start: Time.current.beginning_of_month.iso8601, stop: Time.current.end_of_month.iso8601
  end

  def year
    sum start: Time.current.beginning_of_year.iso8601, stop: Time.current.end_of_year.iso8601
  end

  def all
    sum start: '-10y'
  end

  private

  def last(start)
    result = query <<-QUERY
      #{from_bucket}
      |> #{range(start: start)}
      |> #{measurement_filter}
      |> #{fields_filter}
      |> last()
    QUERY

    result.values.each_with_object(empty_hash) do |table, hash|
      record = table.records.first

      hash[record.values['_field'].to_sym] = record.values['_value']
      hash[:time] ||= Time.zone.parse record.values['_time']
    end
  end

  def sum(start:, stop: nil)
    result = query <<-QUERY
      #{from_bucket}
      |> #{range(start: start, stop: stop)}
      |> #{measurement_filter}
      |> #{fields_filter}
      |> aggregateWindow(every: 1h, fn: mean)
      |> sum()
    QUERY

    result.values.each_with_object(empty_hash) do |table, hash|
      record = table.records.first

      hash[record.values['_field'].to_sym] = record.values['_value']
      hash[:time] ||= Time.zone.parse record.values['_stop']
    end
  end

  def empty_hash
    result = {}
    fields.each do |field|
      result[field] = nil
    end
    result[:time] = nil
    result
  end
end