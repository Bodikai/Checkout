require "checkout"

describe Checkout do

  let(:pricing_rules) { PricingRules.new(
    {"Currency" => "$",
     "FR1" => [3.11, "buy_one_get_one"],
     "AP1" => [5.00, "bundle_discount", 3, 4.50],
     "CF1" => [11.23]}) }
  let(:checkout) { Checkout.new(pricing_rules) }

  context "given empty basket" do
    it "returns $0.00" do
      expect(checkout.total).to eql("$0.00")
    end
  end

  context "given basket including two items on BOGO offer" do
    it "returns correct total" do
      checkout.scan("FR1")
      checkout.scan("AP1")
      checkout.scan("FR1")
      checkout.scan("CF1")
      expect(checkout.total).to eql("$19.34")
    end
  end

  context "given basket with both items on BOGO offer" do
    it "returns correct total taking BOGO offer into account" do
      checkout.scan("FR1")
      checkout.scan("FR1")
      expect(checkout.total).to eql("$3.11")
    end
  end

  context "given basket only including four items on BOGO offer" do
    it "returns correct total taking the BOGO offer into account twice" do
      checkout.scan("FR1")
      checkout.scan("FR1")
      checkout.scan("FR1")
      checkout.scan("FR1")
      expect(checkout.total).to eql("$6.22")
    end
  end

  context "given basket including two items on 3-item bundle discount offer" do
    it "returns correct total NOT taking discount offer into account" do
      checkout.scan("AP1")
      checkout.scan("CF1")
      checkout.scan("FR1")
      checkout.scan("AP1")
      expect(checkout.total).to eql("$24.34")
    end
  end

  context "given basket including three items on bundle discount offer" do
    it "returns correct total taking bundle offer into account" do
      checkout.scan("AP1")
      checkout.scan("AP1")
      checkout.scan("FR1")
      checkout.scan("AP1")
      expect(checkout.total).to eql("$16.61")
    end
  end

  context "given basket including seven items on 3-item bundle discount offer" do
    it "returns correct total taking bundle offer into account" do
      checkout.scan("AP1")
      checkout.scan("AP1")
      checkout.scan("FR1")
      checkout.scan("AP1")
      checkout.scan("AP1")
      checkout.scan("AP1")
      checkout.scan("AP1")
      checkout.scan("AP1")
      expect(checkout.total).to eql("$34.61")
    end
  end

end