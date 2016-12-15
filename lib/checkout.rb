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
    return offer_name
  end

  def offer_price(items, item, occurrence)
    if offer_type(item) == "buy_one_get_one" && occurrence % 2 == 0
      puts "Offer applied: -$#{'%.02f' % product.price(item)} (#{item} BOGO)"
      return product.price(item)
    elsif offer_type(item) == "multiple_discount" && items.count(item) >= @rules[item][1]
      puts "Offer applied: -$#{'%.02f' % (product.price(item) - @rules[item][2])} (#{item} MD)"
      return product.price(item) - @rules[item][2]
    end
    puts "No offer: (#{item})"
    0
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

  def occurrence(i)
    @items[0..i].count(@items[i])
  end

  def offers_total
    deduction = 0
    items = @items.clone
    for i in 0...items.length
      deduction += @pricing_rules.offer_price(items, items[i], occurrence(i))
    end
    puts "Deduction total: -$#{'%.02f' % deduction}"
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
    @total_price = '%.02f' % (total_before_offers - offers_total)
    puts "Final Total: $#{@total_price}"
    "#{product.get_currency}#{@total_price}"
  end
end