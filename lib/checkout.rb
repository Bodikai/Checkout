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
    @items.each_with_index { |item, i|
      @total_price += @pricing_rules.price(@items, @items[i], occurrence(i)) }
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

############ CURRENTLY RE-FACTORING FOLLOWING CLASS

class PricingRules
  def initialize(currency, rules)
    @currency = currency
    @products = initialize_products(rules)
  end

  def currency
    @currency
  end

  def initialize_products(rules)
    products = []
    rules.each do |product_code, product_rules|
      products << new_product(product_code, product_rules)
    end
    products
  end

  def new_product(product_code, product_rules)
    Product.new(product_code, product_rules)
  end

  def price(items, item, occurrence)
    @products.each do |product|
      if product.product_code == item
        return product.price(items, item, occurrence)
      end
    end
    0
  end
end

class EmptyOffer
  def initialize(product_rules)
    @offer_price = 0
  end

  def applies?(items, item, occurrence)
    false
  end

  def offer_price
    @offer_price
  end
end

class BulkDiscountOffer < EmptyOffer
  def initialize(product_rules)
    @bulk_threshold = product_rules[2]
    @offer_price = product_rules[3]
  end

  def applies?(items, item, occurrence)
    items.count(item) >= @bulk_threshold
  end
end

class BuyOneGetOneOffer < EmptyOffer
  def applies?(items, item, occurrence)
    occurrence % 2 == 0
  end
end

class Product
  def initialize(product_code, product_rules)
    @product_code = product_code
    @product_rules = product_rules
    @base_price = product_rules[0]
    @offer = offer_type(product_rules[1])
  end

  def bulk_discount_offer
    BulkDiscountOffer.new(@product_rules)
  end

  def buy_one_get_one_offer
    BuyOneGetOneOffer.new(@product_rules)
  end

  def empty_offer
    EmptyOffer.new(@product_rules)
  end

  def offer_applies?(items, item, occurrence)
    @offer.applies?(items, item, occurrence)
  end

  def offer_type(offer)
    case offer
    when "bulk_discount"
      return bulk_discount_offer
    when "buy_one_get_one"
      return buy_one_get_one_offer
    end
    empty_offer
  end

  def price(items, item, occurrence)
    if offer_applies?(items, item, occurrence)
      return @offer.offer_price
    end
    @base_price
  end

  def product_code
    @product_code
  end
end