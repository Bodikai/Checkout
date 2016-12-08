class PricingRules
  def initialize(rules)
    @rules = rules
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
  end

  def product
    Products.new
  end

  def scan(item)
    @total_price += product.price(item)
  end

  def total
    "#{product.get_currency}#{@total_price}"
  end
end