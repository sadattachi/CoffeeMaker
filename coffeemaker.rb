require "./exceptions"

class CoffeeMaker
  attr_reader :powerState, :currentWaterCapacity, :coffeeInserted

  def initialize(maxCapacity, boilingSpeed)
    @powerState = false
    @coffeeInserted = false
    @maxWaterCapacity = maxCapacity
    @currentWaterCapacity = 0
    @boilingSpeed = boilingSpeed
  end

  def switchPower
    @powerState = !@powerState
  end

  def fillTank
    @currentWaterCapacity = @maxWaterCapacity
  end

  def addGround
    @coffeeInserted = true
  end

  def makeCoffee(message)
    raise NoPowerException.new("No power!") unless @powerState
    raise NotEnoughWaterException.new("Not enough water!") if @currentWaterCapacity < 250
    raise NoCoffeeException.new("No coffee!") unless @coffeeInserted
    system("clear")
    10.step(100, 10) { |i|
      puts "Boiling water #{i} degrees"
      sleep @boilingSpeed
      system("clear")
    }
    puts message
    sleep 3
    @coffeeInserted = false
    @currentWaterCapacity -= 250
  end
end

class FastCoffeeMaker < CoffeeMaker
  def initialize
    super(500, 0.3)
  end

  def getName
    "Fast Coffee Maker"
  end

  def makeCoffee(message = "Enjoy your fast coffee!")
    super
  end
end

class NormalCoffeeMaker < CoffeeMaker
  def initialize
    super(1500, 0.5)
  end

  def getName
    "Coffee Maker"
  end

  def makeCoffee(message = "Enjoy your coffee!")
    super
  end
end

class GroupCoffeeMaker < CoffeeMaker
  def initialize
    super(3000, 1.5)
  end

  def getName
    "Group Coffee Maker"
  end

  def makeCoffee(message = "Enjoy your coffee with friends!")
    super
  end
end
