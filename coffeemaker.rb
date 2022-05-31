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

  def makeCoffee(cup)
    checkState(cup)
    system("clear")
    boilWater()
    puts "Enjoy your #{cup.size}ml coffee!"
    sleep 3
    updateState(cup)
  end

  private

  def boilWater
    10.step(100, 10) { |i|
      puts "Boiling water #{i} degrees"
      sleep @boilingSpeed
      system("clear")
    }
  end

  def updateState(cup)
    @coffeeInserted = false
    @currentWaterCapacity -= cup.size
  end

  def checkState(cup)
    raise NoPowerException.new("No power!") unless @powerState
    raise NotEnoughWaterException.new("Not enough water!") if @currentWaterCapacity < cup.size
    raise NoCoffeeException.new("No coffee!") unless @coffeeInserted
  end
end

class FastCoffeeMaker < CoffeeMaker
  def initialize
    super(500, 0.3)
  end

  def getName
    "Fast Coffee Maker"
  end

  def makeCoffee(cup)
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

  def makeCoffee(cup)
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

  def makeCoffee(cup)
    super
  end
end
