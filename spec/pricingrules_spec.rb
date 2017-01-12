require "checkout"

describe PricingRules do

  let(:pricing_rules) { PricingRules.new(
    "$",
    { "FR1" => [3.11, "buy_one_get_one"],
      "AP1" => [5.00, "bulk_discount", 3, 4.50],
      "CF1" => [11.23]}) }
  let(:co) { Checkout.new(pricing_rules) }

  describe "#initialize_products" do
    context "given a set of pricing rules" do
      it "returns an array containing instances of type Product" do
        array = pricing_rules.initialize_products(
          { "FR1" => [3.11, "buy_one_get_one"],
            "AP1" => [5.00, "bulk_discount", 3, 4.50],
            "CF1" => [11.23] })
        expect(array[0]).to be_an_instance_of(Product)
        expect(array[1]).to be_an_instance_of(Product)
        expect(array[2]).to be_an_instance_of(Product)
      end
    end
  end

  describe "#new_product" do
    context "given a product code and rules" do
      it "returns an instance of type Product" do
        inst = pricing_rules.new_product("FR1", [3.11, "buy_one_get_one"])
        expect(inst).to be_an_instance_of(Product)
      end
    end

    context "given a product code and rules" do
      it "returns a Product instance with the correct product code" do
        inst = pricing_rules.new_product("FR1", [3.11, "buy_one_get_one"])
        expect(inst.product_code).to eql("FR1")
      end
    end

    context "given a product code and rules" do
      it "returns a Product instance with the correct offer type" do
        inst = pricing_rules.new_product("FR1", [3.11, "buy_one_get_one"])
        expect(inst.buy_one_get_one_offer).to be_an_instance_of(BuyOneGetOneOffer)
      end
    end
  end
end