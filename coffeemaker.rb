# frozen_string_literal: true

require './exceptions'
require './coffees'
require './states'
require 'active_support/inflector'

# Base class for coffee makers
class CoffeeMaker
  attr_reader :current_water_capacity, :coffee_inserted, :state

  def initialize(max_capacity, boiling_speed)
    @coffee_inserted = false
    @max_water_capacity = max_capacity
    @current_water_capacity = 0
    @boiling_speed = boiling_speed
    @state = PowerOffState.new
    @state.context = self
  end

  def switch_power
    if @state.is_a? PowerOffState
      transition_to(ReadyState.new)
    else
      transition_to(PowerOffState.new)
    end
  end

  def fill_tank
    @current_water_capacity = @max_water_capacity
  end

  def add_coffee_ground
    @coffee_inserted = true
  end

  def make_coffee(cup)
    check_state(cup)
    system('clear')
    boil_water
    puts "Enjoy your #{cup.size}ml coffee!"
    sleep 3
    update_state(cup)
  end

  def transition_to(state)
    print 'Waiting'
    4.times do
      sleep 0.3
      print '.'
    end
    @state = state
    @state.context = self
    system('clear')
  end

  private

  def action
    @state.action
  end

  def boil_water
    transition_to(BoilingWaterState.new)
    10.step(100, 10) do |i|
      puts "State: #{action}"
      puts "#{i} degrees"
      sleep @boiling_speed
      system('clear')
    end
  end

  def update_state(cup)
    @coffee_inserted = false
    @current_water_capacity -= cup.size
    transition_to(ReadyState.new)
  end

  def check_state(cup)
    raise NoPowerException, 'No power!' if @state.is_a? PowerOffState
    raise NotEnoughWaterException, 'Not enough water!' if @current_water_capacity < cup.size
    raise NoCoffeeException, 'No coffee!' unless @coffee_inserted
  end
end

# Coffee maker with small water capacity and high boiling speed
class FastCoffeeMaker < CoffeeMaker
  def initialize
    super(500, 0.3)
  end

  def name
    'Fast Coffee Maker'
  end
end

# Coffee maker with average water capacity and average boiling speed
class NormalCoffeeMaker < CoffeeMaker
  def initialize
    super(1500, 0.5)
  end

  def name
    'Coffee Maker'
  end
end

# Coffee maker with high water capacity and low boiling speed
class GroupCoffeeMaker < CoffeeMaker
  def initialize
    super(3000, 1.5)
  end

  def name
    'Group Coffee Maker'
  end

  def select_cup_number(cup)
    number = 0
    loop do
      system('clear')
      print "Enter number of cups (1 - #{@current_water_capacity / cup.size}): "
      number = gets.chomp.to_i
      checker = number * cup.size > @current_water_capacity
      if checker
        puts 'To many cups! Try again!'
        sleep 2
      elsif number < 1
        puts 'Wrong input! Try Again!'
        sleep 2
      end
      break unless checker || (number < 1)
    end
    number
  end

  def update_state(water_ml)
    @coffee_inserted = false
    @current_water_capacity -= water_ml
    transition_to(ReadyState.new)
  end

  def make_coffee(cup)
    check_state(cup)
    number = select_cup_number(cup)
    system('clear')
    boil_water
    puts "Enjoy your #{number} #{'cup'.pluralize(number)} of coffee!"
    sleep 3
    system('clear')
    update_state(cup.size * number)
  end
end

# Coffee machine for different coffee types
class CoffeeMachine < CoffeeMaker
  attr_reader :current_milk_capacity, :coffee_count

  def initialize
    super(1500, 0.8)
    @max_milk_capacity = 1000
    @current_milk_capacity = 0
    @coffee_count = 0
  end

  def name
    'Coffee Machine'
  end

  def fill_milk_tank
    @current_milk_capacity = @max_milk_capacity
  end

  def select_coffee
    choice = 0
    loop do
      system('clear')
      puts 'Coffee Selection'.center(50)
      puts 'a - Espresso'
      puts 'b - Latte'
      puts 'c - Cappuccino'
      print 'Enter your choice: '
      choice = gets.chomp
      checker = !(('a'..'c').include? choice)
      if checker
        puts 'Wrong input! Try again!'
        sleep 2
      end
      break unless checker
    end
    choice
  end

  def add_coffee_ground
    @coffee_count = 10
  end

  def make_coffee(_cup)
    coffee = select_coffee
    result = nil
    case coffee
    when 'a' then result = EspressoCreator.new.create_coffee
    when 'b' then result = LatteCreator.new.create_coffee
    when 'c' then result = CappuccinoCreator.new.create_coffee
    end
    check_state(result[1], result[2])
    system('clear')
    boil_water
    pour_milk if (result[2]).positive?
    puts result[0]
    sleep 3
    system('clear')
    update_water(result[1])
    update_milk(result[2])
    update_state
  end

  private

  def pour_milk
    transition_to(PouringMilkState.new)
    system('clear')
    puts "State: #{action}"
    print 'Pouring milk'
    4.times do
      sleep 0.5
      print '.'
    end
    system('clear')
  end

  def update_milk(number)
    @current_milk_capacity -= number
  end

  def update_water(number)
    @current_water_capacity -= number
  end

  def update_state
    transition_to(ReadyState.new)
    @coffee_count -= 1
  end

  def check_state(water, milk)
    raise NoPowerException, 'No power!' if @state.is_a? PowerOffState
    raise NotEnoughWaterException, 'Not enough water!' if @current_water_capacity < water
    raise NotEnoughMilkException, 'Not enough milk!' if @current_milk_capacity < milk
    raise NoCoffeeException, 'No coffee!' if @coffee_count.zero?
  end
end
