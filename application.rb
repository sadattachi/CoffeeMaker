require './coffeemaker'
 
module Application
   def self.run
       menu = Menu.new
       begin
           menu.printMenu
           choice = gets.chomp
           case choice
               when 'a' then menu.switchPower
               when 'b' then menu.fillTank
               when 'c' then menu.addGround
               when 'd' then menu.makeCoffee
           end
       end while choice != 'q'
   end
   class Menu
       def initialize
           @coffeemaker = FastCoffeeMaker.new
       end
       def printMenu
           system("clear")
           puts "Coffee Maker".center(50)
           puts "State: #{@coffeemaker.powerState ? 'on' : 'off'}"
           puts "Coffee grounds: #{@coffeemaker.coffeeInserted ? 'inserted' : 'missing'}"
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
