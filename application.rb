# frozen_string_literal: true

require './coffeemaker'
require './cups'

# Main application module
module Application
  def self.run
    menu = Menu.new
    menu.select_coffee_maker
    loop do
      menu.print_menu
      choice = gets.chomp
      case choice
      when 'a' then menu.switch_power
      when 'b' then menu.fill_tank
      when 'c' then menu.add_ground
      when 'd' then menu.make_coffee
      when 'q' then puts "Bye!"
      when 'm'
        menu.fill_milk_tank if menu.coffee_maker.is_a? CoffeeMachine
      when 'e' then menu.select_coffee_maker
      else
        menu.wrong_input
      end
      break unless choice != 'q'
    end
  end

  # Facade for CoffeeMaker classes
  class Menu
    attr_reader :coffee_maker

    def initialize
      @coffee_maker = nil
    end

    def select_coffee_maker
      loop do
        checker = false
        system('clear')
        puts 'Select Coffee Maker'.center(50)
        puts 'a - Normal'
        puts 'b - Fast'
        puts 'c - For Groups'
        puts 'd - CoffeeMachine'
        print 'Enter your choice: '
        choice = gets.chomp

        case choice
        when 'a' then @coffee_maker = NormalCoffeeMaker.new
        when 'b' then @coffee_maker = FastCoffeeMaker.new
        when 'c' then @coffee_maker = GroupCoffeeMaker.new
        when 'd' then @coffee_maker = CoffeeMachine.new
        else
          checker = true
          wrong_input
        end
        break unless checker
      end
    end

    def print_menu
      system('clear')
      puts @coffee_maker.name.center(50)
      puts "State: #{@coffee_maker.power_state ? 'on' : 'off'}"
      if @coffee_maker.is_a? CoffeeMachine
        puts "Coffee shots: #{@coffee_maker.coffee_count}"
      else
        puts "Coffee grounds: #{@coffee_maker.coffee_inserted ? 'inserted' : 'missing'}"
      end
      puts "Water tank: #{@coffee_maker.current_water_capacity}ml"
      puts "Milk tank: #{@coffee_maker.current_milk_capacity}ml" if @coffee_maker.is_a? CoffeeMachine
      puts 'a - Power Switch'
      puts 'b - Fill water tank'
      if @coffee_maker.is_a? CoffeeMachine
        puts 'c - Add coffee shots'
      else
        puts 'c - Add coffee ground'
      end
      puts 'm - Fill milk tank' if @coffee_maker.is_a? CoffeeMachine
      puts 'd - Make coffee'
      puts 'e - Buy new coffee maker'
      puts 'q - Quit'
      print 'Enter your choice: '
    end

    def wrong_input
      puts 'Wrong input! Try again!'
      sleep 2
    end

    def switch_power
      @coffee_maker.switch_power
    end

    def fill_tank
      @coffee_maker.fill_tank
    end

    def fill_milk_tank
      @coffee_maker.fill_milk_tank
    end

    def add_ground
      @coffee_maker.add_coffee_ground
    end

    def make_coffee
      puts "test"
      cup = if !(@coffee_maker.is_a? CoffeeMachine)
              cup_selection
            else
              MediumCup.new
            end
      @coffee_maker.make_coffee(cup)
    rescue StandardError => e
      puts e.message
      sleep 2
    end

    private

    def cup_selection
      loop do
        system('clear')
        puts 'Select cup'.center(50)
        puts 'a - Small  (250ml)'
        puts 'b - Medium (350ml)'
        puts 'c - Large  (500ml)'
        print 'Enter your choice: '
        choice = gets.chomp

        case choice
        when 'a' then return SmallCup.new
        when 'b' then return MediumCup.new
        when 'c' then return LargeCup.new
        else
          wrong_input
        end
        break unless true
      end
    end
  end
end
