class PricingRules
  def initialize(rules)
    @rules = rules
    @currency = @rules["Currency"]
  end

  def base_price(item)
    @rules[item][0]
  end

  def currency
    @currency
  end

  def offer_type(item)
    offer_name = nil
    if @rules.include?(item)
      if @rules.fetch(item)[1] == "buy_one_get_one"
        offer_name = "buy_one_get_one"
      elsif @rules.fetch(item)[1] == "multiple_discount"
        offer_name = "multiple_discount"
      end
    end
    offer_name
  end

  def price(items, item, occurrence)
    if offer_type(item) == "buy_one_get_one" && occurrence % 2 == 0
      puts "#{item} 1 x #{currency}#{'%.02f' % 0} Buy one get one free"
      return 0
    elsif offer_type(item) == "multiple_discount" && items.count(item) >= @rules[item][2]
      puts "#{item} 1 x #{currency}#{'%.02f' % @rules[item][3]} Discount for #{@rules[item][2]} or more"
      return @rules[item][3]
    end
    puts "#{item} 1 x #{currency}#{'%.02f' % base_price(item)}"
    base_price(item)
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
    for i in 0...@items.length
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
    puts ""
    generate_total
    puts "Total: #{format_total}"
    format_total
  end
end