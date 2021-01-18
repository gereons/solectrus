# TODO: Better styling
# https://stackoverflow.com/questions/62212412/smooth-infinite-animation-flow-with-css
# https://stackoverflow.com/questions/58660120/create-infinite-loop-with-css-keyframes

class Flow::Component < ViewComponent::Base
  def initialize(value:, max:, signal:)
    super
    @value = value.to_f
    @max = max.to_f
    @signal = signal
  end

  attr_accessor :value, :signal

  def height_class # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    if quote < 0.01
      'h-0 border'
    elsif quote < 0.03
      'h-1'
    elsif quote < 0.05
      'h-2'
    elsif quote < 0.1
      'h-3'
    elsif quote < 0.2
      'h-5'
    elsif quote < 0.3
      'h-6'
    elsif quote < 0.4
      'h-7'
    elsif quote < 0.5
      'h-8'
    elsif quote < 0.6
      'h-9'
    elsif quote < 0.7
      'h-10'
    elsif quote < 0.8
      'h-11'
    else
      'h-12'
    end
  end

  def quote
    @quote ||= [ @value / @max, 1.0 ].min
  end
end
