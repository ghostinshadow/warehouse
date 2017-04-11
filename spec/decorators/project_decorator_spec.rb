require 'rails_helper'

RSpec.describe ProjectDecorator do
  subject{ build(:basic_project).decorate }

  describe "#status" do
    it "displays message based on aasm_state" do
      expect(subject.status).to eq("New project")
    end

    it "displays message processed" do
      subject.save
      expect(subject.status).to eq("Saved project")
    end
  end

  describe "#shipping_date" do
    it "displays shipping date" do
      expect(subject.shipping_date).to eq('27/03/2017')
    end
  end

  describe "#prototype_name" do
    it "displays shipping" do
      expect(subject.prototype_name).to eq("Project 23")
    end
  end

  describe ".collection_decorator_class" do
    it "returns pagination decorator class" do
      expect(ProjectDecorator.collection_decorator_class).to eq(PaginatingDecorator)
    end
  end
end
