require "checkout"

describe Checkout do

  let(:pricing_rules) { PricingRules.new(
    "$",
    { "FR1" => [3.11, "buy_one_get_one"],
     "AP1" => [5.00, "bulk_discount", 3, 4.50],
     "CF1" => [11.23]}) }
  let(:co) { Checkout.new(pricing_rules) }

  describe "#format_total" do
    context "given a basket with one item" do
      it "returns the total amount in the correct format" do
        co.scan("FR1")
        co.generate_total
        expect(co.format_total).to eql("$3.11")
      end
    end

    context "given a basket with several items" do
      it "returns the total amount in the correct format" do
        co.scan("FR1")
        co.scan("AP1")
        co.scan("CF1")
        co.generate_total
        expect(co.format_total).to eql("$19.34")
      end
    end
  end

  describe "#generate_total" do
    context "given a basket with one item" do
      it "returns the correct total amount" do
        co.scan("FR1")
        co.generate_total
        expect(co.total_price).to eql(3.11)
      end
    end

    context "given a basket with several items" do
      it "generates the correct total amount" do
        co.scan("FR1")
        co.scan("AP1")
        co.scan("CF1")
        co.generate_total
        expect(co.total_price).to eql(19.34)
      end
    end
  end

  describe "#occurrence" do
    context "given a basket with no duplicate items" do
      it "returns the correct number of occurrances for product 'FR1'" do
        co.scan("FR1")
        co.scan("AP1")
        co.scan("CF1")
        expect(co.occurrence(1)).to eql(1)
      end
    end

    context "given a basket with no duplicate items" do
      it "returns the correct number of occurrances for product 'CF1'" do
        co.scan("FR1")
        co.scan("AP1")
        co.scan("CF1")
        expect(co.occurrence(2)).to eql(1)
      end
    end

    context "given a basket with duplicate items" do
      it "returns the correct number of occurrances for product 'CF1'" do
        co.scan("FR1")
        co.scan("CF1")
        co.scan("AP1")
        co.scan("CF1")
        expect(co.occurrence(3)).to eql(2)
      end
    end
  end

  describe "#scan" do
    context "given product 'FR1' as a new item" do
      it "correctly adds the item to the item list" do
        co.scan("FR1")
        expect(co.items).to eql(["FR1"])
      end
    end

    context "given several new items" do
      it "correctly adds all new items to the item list" do
        co.scan("FR1")
        co.scan("AP1")
        co.scan("CF1")
        expect(co.items).to eql(["FR1", "AP1", "CF1"])        
      end
    end
  end

  describe "#total" do
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
end