# frozen_string_literal: true

# Base class for coffee creators
class Creator
  def factory_method
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def create_coffee
    product = factory_method
    product.operation
  end
end

# Returns Espresso
class EspressoCreator < Creator
  def factory_method
    Espresso.new
  end
end

# Returns Latte
class LatteCreator < Creator
  def factory_method
    Latte.new
  end
end

# Returns Cappuccino
class CappuccinoCreator < Creator
  def factory_method
    Cappuccino.new
  end
end

# Base class for every coffee type
class Coffee
  def operation
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Returns Espresso info
class Espresso < Coffee
  def operation
    ['Enjoy your espresso!', 200, 0]
  end
end

# Returns Latte info
class Latte < Coffee
  def operation
    ['Enjoy your latte!', 100, 200]
  end
end

# Returns Cappuccino info
class Cappuccino < Coffee
  def operation
    ['Enjoy your cappuccino!', 100, 250]
  end
end
