class PricingRules
  def initialize(rules)
    @rules = rules
  end

  def offer(item)
    if @rules.include?(item)
      if @rules.fetch(item) == "BOGO"
        return "BOGO"
      end
    end
    return nil
  end

end

class Products
  def initialize
    @prices = Hash.new
    @prices["FR1"] = 3.11
    @prices["AP1"] = 5.00
    @prices["CF1"] = 11.23
    @currency = "$"
  end

  def get_currency
    @currency
  end

  def price(item)
    @prices[item]
  end
end

class Checkout
  def initialize(rules)
    @pricing_rules = rules
    @total_price = 0
    @items = []
  end

  def product
    Products.new
  end

  def offers_total
    deduction = 0
    items = @items.clone
    for i in 0...items.length
      if @pricing_rules.offer(items[i]) == "BOGO"
        for j in i+1...items.length
          if items[j] == items[i]
            deduction += product.price(items[i])
            puts "Offer deduction subtotal: $#{deduction.round(2)} (#{items[j]} #{@pricing_rules.offer(items[j])})"
            items[j] = ""
            break
          end
        end
      end
    end
    deduction
  end

  def scan(item)
    @items << item
  end

  def total_before_offers
    total = 0
    @items.each do |i|
      total += product.price(i)
      puts "Subtotal: $#{total.round(2)} (#{i})"
    end
    total
  end

  def total
    puts "----------------------"
    @total_price = (total_before_offers - offers_total).round(2)
    puts "Final Total: $#{@total_price.round(2)}"
    "#{product.get_currency}#{@total_price}"
  end
end