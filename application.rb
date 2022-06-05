require "./coffeemaker"
require "./cups"

module Application
  def self.run
    menu = Menu.new
    menu.selectCoffeeMaker
    begin
      menu.printMenu
      choice = gets.chomp
      case choice
      when "a" then menu.switchPower
      when "b" then menu.fillTank
      when "c" then menu.addGround
      when "d" then menu.makeCoffee
      when "m"
        menu.fillMilkTank if menu.coffeemaker.is_a? CoffeeMachine
      when "e" then menu.selectCoffeeMaker
      end
    end while choice != "q"
  end

  class Menu
    attr_reader :coffeemaker

    def initialize
      @coffeemaker = nil
    end

    def selectCoffeeMaker
      system("clear")
      puts "Select Coffee Maker".center(50)
      puts "a - Normal"
      puts "b - Fast"
      puts "c - For Groups"
      puts "d - CoffeeMachine"
      print "Enter your choice: "
      choice = gets.chomp

      case choice
      when "a" then @coffeemaker = NormalCoffeeMaker.new
      when "b" then @coffeemaker = FastCoffeeMaker.new
      when "c" then @coffeemaker = GroupCoffeeMaker.new
      when "d" then @coffeemaker = CoffeeMachine.new
      end
    end

    def printMenu
      system("clear")
      puts @coffeemaker.getName.center(50)
      puts "State: #{@coffeemaker.powerState ? "on" : "off"}"
      if @coffeemaker.is_a? CoffeeMachine
        puts "Coffee shots: #{@coffeemaker.coffeeCount}"
      else
        puts "Coffee grounds: #{@coffeemaker.coffeeInserted ? "inserted" : "missing"}"
      end
      puts "Water tank: #{@coffeemaker.currentWaterCapacity}ml"
      puts "Milk tank: #{@coffeemaker.currentMilkCapacity}ml" if @coffeemaker.is_a? CoffeeMachine
      puts "a - Power Switch"
      puts "b - Fill water tank"
      if @coffeemaker.is_a? CoffeeMachine
        puts "c - Add coffee shots"
      else
        puts "c - Add coffee ground"
      end
      puts "m - Fill milk tank" if @coffeemaker.is_a? CoffeeMachine
      puts "d - Make coffee"
      puts "e - Buy new coffee maker"
      puts "q - Quit"
      print "Enter your choice: "
    end

    def switchPower
      @coffeemaker.switchPower
    end

    def fillTank
      @coffeemaker.fillTank
    end

    def fillMilkTank
      @coffeemaker.fillMilkTank
    end

    def addGround
      @coffeemaker.addGround
    end

    def makeCoffee
      begin
        if !(@coffeemaker.is_a? CoffeeMachine)
          cup = cupSelection()
        else
          cup = MediumCup.new
        end
        @coffeemaker.makeCoffee(cup)
      rescue => e
        puts e.message
        sleep 2
      end
    end

    private

    def cupSelection
      begin
        puts "Select cup".center(50)
        puts "a - Small  (250ml)"
        puts "b - Medium (350ml)"
        puts "c - Large  (500ml)"
        print "Enter your choice: "
        choice = gets.chomp

        case choice
        when "a" then return SmallCup.new
        when "b" then return MediumCup.new
        when "c" then return LargeCup.new
        else puts "Try again!"
        end
        puts "outside"
      end while true
    end
  end
end
