class PricingRules
  def initialize(rules)
    @rules = rules
  end

  def offer_type(item)
    offer_name = nil
    if @rules.include?(item)
      if @rules.fetch(item) == "buy_one_get_one"
        offer_name = "buy_one_get_one"
      elsif @rules.fetch(item)[0] == "multiple_discount"
        offer_name = "multiple_discount"
      end
    end
    offer_name
  end

  def price(items, item, occurrence)
    if offer_type(item) == "buy_one_get_one" && occurrence % 2 == 0
      puts "#{item} 1 x #{product.currency}#{'%.02f' % 0} Buy one get one free"
      return 0
    elsif offer_type(item) == "multiple_discount" && items.count(item) >= @rules[item][1]
      puts "#{item} 1 x #{product.currency}#{'%.02f' % @rules[item][2]} Discount for 3 or more"
      return @rules[item][2]
    end
    puts "#{item} 1 x #{product.currency}#{'%.02f' % product.price(item)}"
    product.price(item)
  end

  def product
    Products.new
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

  def currency
    @currency
  end

  def price(item)
    @prices[item]
  end
end

class Checkout
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @total_price = 0
    @items = []
  end

  def format_total
    "#{product.currency}#{'%.02f' % @total_price}"
  end

  def generate_total
    for i in 0...@items.length
      @total_price += @pricing_rules.price(@items, @items[i], occurrence(i))
    end
  end

  def occurrence(i)
    @items[0..i].count(@items[i])
  end

  def product
    Products.new
  end

  def scan(item)
    @items << item
  end

  def total
    puts ""
    generate_total
    puts "Total: #{format_total}"
    format_total
  end
end