class Scale
  def initialize(max:, target: 0..100)
    @max = max || 0
    @target = target
  end

  attr_reader :max, :target

  def result(value)
    return 0 if value.nil? || value.zero?

    lower_bound +
      (extent * (Math.log(value)**FACTOR) / (Math.log(max)**FACTOR)).round
  end

  private

  def lower_bound
    target.first
  end

  def extent
    target.size - 1
  end

  # Damping factor, play around to find the best one
  FACTOR = 6
  private_constant :FACTOR
end
