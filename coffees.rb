class Creator
  def factory_method
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def getCoffee
    product = factory_method
    product.operation
  end
end

class EspressoCreator < Creator
  def factory_method
    Espresso.new
  end
end

class LatteCreator < Creator
  def factory_method
    Latte.new
  end
end

class CappuccinoCreator < Creator
  def factory_method
    Cappuccino.new
  end
end

class Coffee
  def operation
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class Espresso < Coffee
  def operation
    ["Enjoy your espresso!", 200, 0]
  end
end

class Latte < Coffee
  def operation
    ["Enjoy your latte!", 100, 200]
  end
end

class Cappuccino < Coffee
  def operation
    ["Enjoy your cappuccino!", 100, 250]
  end
end
