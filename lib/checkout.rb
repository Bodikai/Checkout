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

class PricingRules
  # consider replacing this with class for products which contains
  # rules for which offers are applicable to it

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
    # NOTE: What happens if product not found?
  end
end

class BulkDiscountOffer
  def initialize(bulk_threshold)
    @bulk_threshold = bulk_threshold
  end

  def apply?(items, item)
    items.count(item) >= @bulk_threshold
  end
end

class BuyOneGetOneOffer
  def apply?(occurrence)
    occurrence % 2 == 0
  end
end

class Product
  def initialize(product_code, product_rules)
    @product_code = product_code
    @base_price = product_rules[0]
    if product_rules.length > 1
      @offer_type = product_rules[1]
      if @offer_type == "bulk_discount"
        @bulk_threshold = product_rules[2]
        @offer_price = product_rules[3]
      elsif @offer_type == "buy_one_get_one"
        @offer_price = 0
      end
    end
  end

  def price(items, item, occurrence)
    if @offer_type == "bulk_discount" && bulk_discount.apply?(items, item)
      return @offer_price
    elsif @offer_type == "buy_one_get_one" && buy_one_get_one.apply?(occurrence)
      return @offer_price
    end
    @base_price
  end

  def product_code
    @product_code
  end

  def offer_applies?

  end

  def bulk_discount
    BulkDiscountOffer.new(@bulk_threshold)
  end

  def buy_one_get_one
    BuyOneGetOneOffer.new
  end
end