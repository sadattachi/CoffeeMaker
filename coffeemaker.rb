require './exceptions'
 
class CoffeeMaker
   attr_reader :powerState, :currentWaterCapacity, :coffeeInserted
   def initialize(maxCapacity = 1500)
       @powerState = false
       @coffeeInserted = false
       @maxWaterCapacity = maxCapacity
       @currentWaterCapacity = 0
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
   def makeCoffee(speed = 0.5, message = "Enjoy your coffee!")
       raise NoPowerException.new("No power!") unless @powerState
       raise NotEnoughWaterException.new("Not enough water!") if @currentWaterCapacity < 250
       raise NoCoffeeException.new("No coffee!") unless @coffeeInserted
       system("clear")
       10.step(100, 10) {|i|
           puts "Boiling water #{i} degrees"
           sleep speed
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
       super(500)
   end
   def makeCoffee(speed = 0.1, message = "Enjoy your fast coffee!")
       super
   end
 
end
