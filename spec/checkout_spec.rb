require "checkout"

describe Checkout do

  let(:pricing_rules) { PricingRules.new(
    "$",
    { "FR1" => [3.11, "buy_one_get_one"],
     "AP1" => [5.00, "bulk_discount", 3, 4.50],
     "CF1" => [11.23]}) }
  let(:co) { Checkout.new(pricing_rules) }

  context "given empty basket" do
    it "returns $0.00" do
      expect(co.total).to eql("$0.00")
    end
  end

  context "given basket including two items on BOGO offer" do
    it "returns correct total" do
      co.scan("FR1")
      co.scan("AP1")
      co.scan("FR1")
      co.scan("CF1")
      expect(co.total).to eql("$19.34")
    end
  end

  context "given basket with both items on BOGO offer" do
    it "returns correct total taking BOGO offer into account" do
      co.scan("FR1")
      co.scan("FR1")
      expect(co.total).to eql("$3.11")
    end
  end

  context "given basket only including four items on BOGO offer" do
    it "returns correct total taking the BOGO offer into account twice" do
      co.scan("FR1")
      co.scan("FR1")
      co.scan("FR1")
      co.scan("FR1")
      expect(co.total).to eql("$6.22")
    end
  end

  context "given basket including two items on 3-item bundle discount offer" do
    it "returns correct total NOT taking discount offer into account" do
      co.scan("AP1")
      co.scan("CF1")
      co.scan("FR1")
      co.scan("AP1")
      expect(co.total).to eql("$24.34")
    end
  end

  context "given basket including three items on bundle discount offer" do
    it "returns correct total taking bundle offer into account" do
      co.scan("AP1")
      co.scan("AP1")
      co.scan("FR1")
      co.scan("AP1")
      expect(co.total).to eql("$16.61")
    end
  end

  context "given basket including seven items on 3-item bundle discount offer" do
    it "returns correct total taking bundle offer into account" do
      co.scan("AP1")
      co.scan("AP1")
      co.scan("FR1")
      co.scan("AP1")
      co.scan("AP1")
      co.scan("AP1")
      co.scan("AP1")
      co.scan("AP1")
      expect(co.total).to eql("$34.61")
    end
  end

end