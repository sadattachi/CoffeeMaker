class Cup
  attr_reader :size

  def initialize(size)
    @size = size
  end
end

class SmallCup < Cup
  def initialize
    super(250)
  end
end

class MediumCup < Cup
  def initialize
    super(350)
  end
end

class LargeCup < Cup
  def initialize
    super(500)
  end
end
