class Offers
  def base_price(item)
    @rules[item][0]
  end

  def bulk_discount?(items, item)
    offer_type(item) == "bulk_discount" && items.count(item) >= @rules[item][2]
  end

  def buy_one_get_one?(item, occurrence)
    offer_type(item) == "buy_one_get_one" && occurrence % 2 == 0
  end

  def offer_price(rules, items, item, occurrence)
    @rules = rules
    if buy_one_get_one?(item, occurrence)
      return 0
    elsif bulk_discount?(items, item)
      return @rules[item][3]
    end
    base_price(item)
  end

  def offer_type(item)
    @rules.fetch(item)[1]
  end
end

class PricingRules
  def initialize(rules)
    @rules = rules
    @currency = @rules["Currency"]
  end

  def currency
    @currency
  end

  def offers
    Offers.new
  end

  def price(items, item, occurrence)
    offers.offer_price(@rules, items, item, occurrence)
  end
end

class Checkout
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @total_price = 0
    @items = []
  end

  def format_total
    "#{@pricing_rules.currency}#{'%.02f' % @total_price}"
  end

  def generate_total
    for i in 0...@items.size
      @total_price += @pricing_rules.price(@items, @items[i], occurrence(i))
    end
  end

  def occurrence(i)
    @items[0..i].count(@items[i])
  end

  def scan(item)
    @items << item
  end

  def total
    # puts ""
    generate_total
    # puts "Total: #{format_total}"
    format_total
  end
end