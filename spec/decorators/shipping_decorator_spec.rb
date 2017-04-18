require 'rails_helper'

RSpec.describe ShippingDecorator do
  let(:shipping) { create(:income_shipping, shipping_date: "2017-03-27").decorate }
  subject { shipping }

  describe "#shipping_date" do
    it "expected to format shipping date" do
      expect(subject.shipping_date).to eq('27/03/2017')
    end

  end

  describe "#package" do
    it "expected to show package name" do
      expect(subject.package).to eq('прихід')
    end
  end

  describe "#project_structure" do
    it "returns"
  end

  describe "#project_name"

  describe "#project_resources"

  describe "#to_s" do
    it "transforms into string" do
      expect(subject.to_s).to eq("прихід - 27/03/2017")
    end
  end

  xdescribe "#full_name" do
    it "should respond to :full_name" do
      is_expected.to respond_to(:full_name)
    end
  end
end
