require "./exceptions"
require "./coffees"
require "active_support/inflector"

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

  def selectCupNumber(cup)
    begin
      system("clear")
      print "Enter number of cups (1 - #{@currentWaterCapacity / cup.size}): "
      number = gets.chomp.to_i
      checker = number * cup.size > @currentWaterCapacity
      if checker
        puts "To many cups! Try again!"
        sleep 2
      elsif number < 1
        puts "Wrong input! Try Again!"
        sleep 2
      end
    end while checker or number < 1
    number
  end

  def updateState(ml)
    @coffeeInserted = false
    @currentWaterCapacity -= ml
  end

  def makeCoffee(cup)
    checkState(cup)
    number = selectCupNumber(cup)
    system("clear")
    boilWater()
    puts "Enjoy your #{number} #{"cup".pluralize(number)} of coffee!"
    sleep 3
    updateState(cup.size * number)
  end
end

class CoffeeMachine < CoffeeMaker
  attr_reader :currentMilkCapacity, :coffeeCount

  def initialize
    super(1500, 0.8)
    @maxMilkCapacity = 1000
    @currentMilkCapacity = 0
    @coffeeCount = 0
  end

  def getName
    "Coffee Machine"
  end

  def fillMilkTank
    @currentMilkCapacity = @maxMilkCapacity
  end

  def selectCoffee
    begin
      system("clear")
      puts "Coffee Selection".center(50)
      puts "a - Espresso"
      puts "b - Latte"
      puts "c - Cappuccino"
      print "Enter your choice: "
      choice = gets.chomp
      checker = !(("a".."c").include? choice)
      if checker
        puts "Wrong input! Try again!"
        sleep 2
      end
    end while checker
    choice
  end

  def addGround
    @coffeeCount = 10
  end

  def makeCoffee(cup)
    coffee = selectCoffee()
    result = nil
    case coffee
    when "a" then result = EspressoCreator.new.getCoffee
    when "b" then result = LatteCreator.new.getCoffee
    when "c" then result = CappuccinoCreator.new.getCoffee
    end
    checkState(result[1], result[2])
    system("clear")
    boilWater()
    pourMilk() if result[2] > 0
    puts result[0]
    sleep 3
    updateWater(result[1])
    updateMilk(result[2])
    updateState()
  end

  private

  def pourMilk
    system("clear")
    print "Pouring milk"
    4.times do
      sleep 0.5
      print "."
    end
    system("clear")
  end

  def updateMilk(number)
    @currentMilkCapacity -= number
  end

  def updateWater(number)
    @currentWaterCapacity -= number
  end

  def updateState
    @coffeeCount -= 1
  end

  def checkState(water, milk)
    raise NoPowerException.new("No power!") unless @powerState
    raise NotEnoughWaterException.new("Not enough water!") if @currentWaterCapacity < water
    raise NotEnoughMilkException.new("Not enough milk!") if @currentMilkCapacity < milk
    raise NoCoffeeException.new("No coffee!") if @coffeeCount == 0
  end
end
