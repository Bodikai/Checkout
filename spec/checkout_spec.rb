require "checkout"

describe Checkout do

  let(:pricing_rules) { PricingRules.new({"FR1" => "BOGO"}) }
  let(:checkout) { Checkout.new(pricing_rules) }

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

    end
  end

  context "given a basket including three items with a discount offer" do
    it "returns the correct total taking the discount offer into account" do

    end
  end

end