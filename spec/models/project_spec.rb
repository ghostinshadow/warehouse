require 'rails_helper'

RSpec.describe Project, type: :model do

  describe "includes AASM behaviour" do
    it "includes module AASM" do
      expect(described_class.included_modules).to include(AASM)
    end
  end

  describe "#initialize" do

    it "provides default value for :aasm_state" do
      expect(subject.aasm_state).to eq('new')
    end

  end

  describe "state machine behaviour" do

    describe "state :new" do

      it "responds to transition method" do
        expect(subject.may_build?).to be true
      end

      it "not responds to #approve?, #complete?, #reset?" do
        responses = responds_to_transitions([:approve, :complete, :reset])

        expect(responses).to all( be false )
      end

      it "transitions from state new to state built"  do
        expect{subject.build}.to change{subject.aasm_state}.from('new').to('built')
      end
    end

    describe "state :built" do
      before(:example){ subject.aasm_state = 'built'}

      it "responds to transition method" do
        allow(subject).to receive(:shipping).and_return(true)
        expect(subject.may_approve?).to be true
      end

      it "responds to transition method" do
        allow(subject).to receive(:shipping).and_return(true)
        expect(subject.may_reset?).to be true
      end

      it "not responds to #build?, #complete?" do
        responses = responds_to_transitions([:build, :complete])

        expect(responses).to all( be false )
      end

      it "transitions from state new to state built"  do
        subject.shipping = build(:shipping)
        expect{subject.approve}.to change{subject.aasm_state}.from('built').to('approved')
      end

      it "shouldn't  revert package while transition to :reset" do
        subject.shipping = build(:shipping)

        expect(subject.shipping).to_not receive(:revert_package)
        subject.reset
      end
    end

    describe "state :approved" do
      before(:example){ subject.aasm_state = 'approved'}

      it "responds to transition method" do
        allow(subject).to receive(:shipping).and_return(true)
        expect(subject.may_complete?).to be true
      end

      it "not responds to #build?, #approve?, #reset?" do
        responses = responds_to_transitions([:build, :approve, :reset])

        expect(responses).to all( be false )
      end

      it "transitions from state new to state built"  do
        subject.shipping = build(:shipping)

        expect{subject.complete}.to change{subject.aasm_state}.from('approved').to('completed')
      end

      it "should process package while transition" do
        subject.shipping = build(:shipping)

        expect(subject.shipping).to receive(:process_package)
        subject.complete
      end
    end

    describe "state :completed" do
      before(:example){ subject.aasm_state = 'completed'}

      it "responds to transition method" do
        allow(subject).to receive(:shipping).and_return(true)
        expect(subject.may_reset?).to be true
      end

      it "not responds to #build?, #approve?, #complete?" do
        responses = responds_to_transitions([:build, :approve, :complete])

        expect(responses).to all( be false )
      end

      it "transitions from state new to state built"  do
        subject.shipping = build(:shipping)

        expect{subject.reset}.to change{subject.aasm_state}.from('completed').to('new')
      end

      it "should revert package while transition" do
        subject.shipping = build(:shipping)

        expect(subject.shipping).to receive(:revert_package)
        subject.reset
      end

    end
  end

  describe ".create" do
    it "not persists if no options given" do
      expect(Project.create).to_not be_persisted
    end

    it "persists if shipping is provided" do
      project = Project.create do |p|
        p.shipping = create(:income_shipping)
      end
      expect(project).to be_persisted
    end

    it "transitions to :built state" do
      project = Project.create do |p|
        p.shipping = create(:income_shipping)
      end

      expect(project).to be_built
    end
  end

  describe ".all_states" do
    it "returns array of 4 elements" do
      expect(Project.all_states.count).to eq(4)
    end

    it "returns :new, :built, :approved, :completed" do
      expect(Project.all_states).to include(:new, :built, :approved, :completed)
    end
  end

  describe "#destroy" do
    it "resets state" do
      project = build(:basic_project, shipping: create(:income_shipping))
      allow(project.shipping).to receive(:revert_package)
      allow(project.shipping).to receive(:process_package)
      project.save

      project.approve
      project.complete

      expect(project).to receive(:reset)
      project.destroy
    end
  end

  def responds_to_transitions(transitions)
    transitions.map{|transition| subject.public_send("may_#{transition}?") }
  end
end
