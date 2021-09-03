
# require '/Users/kitamuramoeka/workspace/vending_machine/vm.rb'  pwdでパスを確認できる

class VendingMachineToCompany
  MONEY = [10, 50, 100, 500, 1000].freeze 
  def initialize
    @slot_money = 0
    @sales_money = 0
  end

  def sales
    @sales_money
  end
  def current_slot_money
    @slot_money 
  end
  def return_money
    puts @slot_money
    @slot_money = 0
  end
  def slot_money(money)
    return false unless MONEY.include?(money)
    @slot_money += money
  end
end

class VendingMachine < VendingMachineToCompany
  
  def initialize
    super
    @drink = Drink.new
    @previousdrink = nil
    @flug = []
  end
  
  def drink_charge(drink)
    begin
      charge_drink = @drink.send(drink)
      charge_drink[:stock] += 1
    rescue
      puts "正しい商品をいれて下さい"
    end
  end

  def drink_discard(drink)
    begin
      discard_drink = @drink.send(drink)
      discard_drink[:stock] -= 1
    rescue
      puts "正しい商品を選んで下さい"
    end
  end

  def info
    @drink
  end

  def buy(drink)
    begin
      buy_drink = @drink.send(drink)
      if @slot_money >= buy_drink[:price] && buy_drink[:stock] > 0
        if @previousdrink == drink
          @flug << drink
        end
        if @flug.length == 2
          puts "#{drink}3連続"
          @flug = []
        end
        buy_drink[:stock]-=1
        @sales_money += buy_drink[:price]
        @slot_money -= buy_drink[:price]
        puts "お買い上げありがとうございます！！"
        @previousdrink = drink

        @slot_money
      else
        false
      end
    rescue
        puts "正しい商品を選んで下さい"
    end
  end

  def list
    lists = []
    lists << "coke" if @slot_money >= @drink.coke[:price] && @drink.coke[:stock] > 0
    lists << "redbull" if @slot_money >= @drink.redbull[:price] && @drink.redbull[:stock] > 0
    lists << "water" if @slot_money >= @drink.water[:price] && @drink.water[:stock] > 0 
    lists
  end
  
end

class Drink
  attr_accessor :coke, :redbull, :water
  def initialize
    @coke = {price:120, name:'coke', stock: 5}
    @redbull = {price:200, name:'redbull', stock: 5}
    @water = {price:100, name:'water', stock: 5}
  end
end


