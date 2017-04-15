require "cancan/matchers"

describe User do
  RESOURCES_CLASSES = ["Project","Dictionary","ProjectPrototype",
                       "DailyCurrency","Shipping","Resource","Word"]

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

  describe "#approve" do
    context "guest user" do
      subject{ build(:guest) }

      it "can be approved" do
        expect{ subject.approve! }.to change{subject.role}.from("guest").to("user")
      end

      it "saves data" do
        expect{ subject.approve! }.to change{subject.persisted?}.from(false).to(true)
      end
    end

    context "other role" do
      subject{ build(:admin)}

      it "not changes role" do
        expect{ subject.approve! }.not_to change{subject.role}
      end

      it "not persists" do
        expect{ subject.approve! }.not_to change{subject.persisted?}
      end
    end
  end


  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:user){ nil }

    context "when is an guest" do
      let(:user){ create(:guest) }

      context "cannot access anything" do

        RESOURCES_CLASSES.each do |klass|

          it "cannot access new action for #{klass}"  do
            expect(ability).to_not be_able_to(:read, klass.constantize)
          end

        end
      end
    end

    context "when is an admin" do
      let(:user){ create(:admin)}

      it "can access admin namespace" do
        is_expected.to be_able_to(:read, :admin)
      end

      it "can access anything" do
        expect(ability).to be_able_to(:manage, :all)
      end
    end

    context "when is an user" do
      let(:user){ create(:user)}

      it "cannot access admin namespace" do
        is_expected.to_not be_able_to(:read, [:admin, :comments])
      end

      describe "projects" do

        let!(:object) { Project.new }

        it_behaves_like "available resource", Project

        it "cannot approve project" do
          is_expected.to_not be_able_to(:update, object)
        end

        it "can manage project" do
          is_expected.to be_able_to(:manage, object)
        end

      end

      describe "project_prototypes" do
        it {is_expected.to be_able_to(:show, ProjectPrototype)}
      end

      describe "dictionaries" do
        it {is_expected.to be_able_to(:update, Dictionary)}

        it_behaves_like "available resource", Dictionary
      end

      describe "daily_currencies" do
        it_behaves_like "available resource", DailyCurrency

        it {is_expected.to be_able_to(:create, DailyCurrency)}
        it {is_expected.to be_able_to(:update, DailyCurrency)}
      end

      describe "shippings" do
        it {is_expected.to be_able_to(:create, Shipping)}
        it_behaves_like "available resource", Shipping
      end

      describe "structure elements" do
        it {is_expected.to be_able_to(:new, Shipping)}
      end

      describe "resources" do
        it_behaves_like "available resource", Resource

        it {is_expected.to be_able_to(:create, Resource)}
        it {is_expected.to be_able_to(:update, Resource)}
      end

      describe "words" do
        it_behaves_like "available resource", Word

        it {is_expected.to be_able_to(:create, Word)}
        it {is_expected.to be_able_to(:update, Word)}
      end
    end

  end

end
