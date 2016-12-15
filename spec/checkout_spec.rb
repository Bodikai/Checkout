require "checkout"

describe Checkout do

  let(:pricing_rules) { PricingRules.new(
    {"Currency" => "$",
     "FR1" => [3.11, "buy_one_get_one"],
     "AP1" => [5.00, "bundle_discount", 3, 4.50],
     "CF1" => [11.23]}) }
  let(:checkout) { Checkout.new(pricing_rules) }

  context "given an empty basket" do
    it "returns a Final Total of $0.00" do
      expect(checkout.total).to eql("$0.00")
    end
  end

  context "given a basket including two items with a BOGO offer" do
    it "returns the correct total taking the BOGO offer into account" do
      checkout.scan("FR1")
      checkout.scan("AP1")
      checkout.scan("FR1")
      checkout.scan("CF1")
      expect(checkout.total).to eql("$19.34")
    end
  end

  context "given a basket only including two items with a BOGO offer" do
    it "returns the correct total taking the BOGO offer into account" do
      checkout.scan("FR1")
      checkout.scan("FR1")
      expect(checkout.total).to eql("$3.11")
    end
  end

  context "given a basket only including four items with a BOGO offer" do
    it "returns the correct total taking the BOGO offer into account twice" do
      checkout.scan("FR1")
      checkout.scan("FR1")
      checkout.scan("FR1")
      checkout.scan("FR1")
      expect(checkout.total).to eql("$6.22")
    end
  end

  context "given a basket including two items with a three-item discount offer" do
    it "returns the correct total NOT taking discount offer into account" do
      checkout.scan("AP1")
      checkout.scan("CF1")
      checkout.scan("FR1")
      checkout.scan("AP1")
      expect(checkout.total).to eql("$24.34")
    end
  end

  context "given a basket including three items with a discount offer" do
    it "returns the correct total taking the discount offer into account" do
      checkout.scan("AP1")
      checkout.scan("AP1")
      checkout.scan("FR1")
      checkout.scan("AP1")
      expect(checkout.total).to eql("$16.61")
    end
  end

  context "given a basket including seven items with a discount offer" do
    it "returns the correct total taking the discount offer into account" do
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