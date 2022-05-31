require "./coffeemaker"

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
      end
    end while choice != "q"
  end

  class Menu
    def initialize
      @coffeemaker = nil
    end

    def selectCoffeeMaker
      system("clear")
      puts "Select Coffee Maker".center(50)
      puts "a - Normal"
      puts "b - Fast"
      puts "c - For Groups"
      print "Enter your choice: "
      choice = gets.chomp

      case choice
      when "a" then @coffeemaker = NormalCoffeeMaker.new
      when "b" then @coffeemaker = FastCoffeeMaker.new
      when "c" then @coffeemaker = GroupCoffeeMaker.new
      end
    end

    def printMenu
      system("clear")
      puts @coffeemaker.getName.center(50)
      puts "State: #{@coffeemaker.powerState ? "on" : "off"}"
      puts "Coffee grounds: #{@coffeemaker.coffeeInserted ? "inserted" : "missing"}"
      puts "Water tank: #{@coffeemaker.currentWaterCapacity}ml"
      puts "a - Power Switch"
      puts "b - Fill water tank"
      puts "c - Add coffee ground"
      puts "d - Make coffee"
      puts "q - Quit"
      print "Enter your choice: "
    end

    def switchPower
      @coffeemaker.switchPower
    end

    def fillTank
      @coffeemaker.fillTank
    end

    def addGround
      @coffeemaker.addGround
    end

    def makeCoffee
      begin
        @coffeemaker.makeCoffee
      rescue => e
        puts e.message
        sleep 2
      end
    end
  end
end
