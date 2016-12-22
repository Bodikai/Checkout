class Offers
  def initialize(rules)
    @rules = rules
  end

  def base_price(item)
    @rules[item][0]
  end

  # Create classes for offers and relevant checks

  def bulk_discount_applicable?(items, item)
    is_offer_type?(item, "bulk_discount") && items.count(item) >= @rules[item][2]
  end

  def buy_one_get_one_offer_applicable?(item, occurrence)
    is_offer_type?(item, "buy_one_get_one") && occurrence % 2 == 0
  end

  def is_offer_type?(item, offer_name)
    @rules.fetch(item)[1] == offer_name
  end

  def offer_price(items, item, occurrence)
    # Use CASE statement
    price = nil
    price ||= price_if_buy_one_get_one_offer(item, occurrence)
    price ||= price_if_bulk_discount_offer(items, item)
    price ||= base_price(item)
  end

  def price_if_bulk_discount_offer(items, item)
    # Always have this return something OTHER than nil
    if bulk_discount_applicable?(items, item)
      return @rules[item][3]
    end
  end

  def price_if_buy_one_get_one_offer(item, occurrence)
    # Always have this return something OTHER than nil

    if buy_one_get_one_offer_applicable?(item, occurrence)
      return 0
    end
  end
end

class PricingRules
  # consider replacing this with class for products which contains rules for which
  # offers are applicable to it

  def initialize(rules)
    @rules = rules
  end

  def currency
    @rules.fetch("Currency")  
  end

  def offers
    Offers.new(@rules)
  end

  def price(items, item, occurrence)
    offers.offer_price(items, item, occurrence)
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
      #replace for loop with EACH with INDEX
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
    generate_total
    format_total
  end
end