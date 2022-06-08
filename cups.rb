# frozen_string_literal: true

# Base class for different cups
class Cup
  attr_reader :size

  def initialize(size)
    @size = size
  end
end

# 250ml cup
class SmallCup < Cup
  def initialize
    super(250)
  end
end

# 350ml cup
class MediumCup < Cup
  def initialize
    super(350)
  end
end

# 500ml cup
class LargeCup < Cup
  def initialize
    super(500)
  end
end
