require "cancan/matchers"

describe User do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end


  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:user){ nil }

    context "when is an guest" do
      let(:user){ create(:guest) }

      it "cannot access anything" do
        expect(ability).to_not be_able_to(:read, Project.new)
      end
    end

    context "when is an admin" do
      let(:user){ create(:admin)}

      it "can access anything" do
        expect(ability).to be_able_to(:manage, :all)
      end
    end

    context "when is an user" do
      let(:user){ create(:user)}

      it "can read all" do
        is_expected.to be_able_to(:read, :all)
      end

      describe "projects" do

        it "cannot approve project" do
          is_expected.to_not be_able_to(:update, Project.new)
        end

        it "can manage project" do
          is_expected.to be_able_to(:manage, Project.new)
        end

      end

      describe "project_prototypes" do
        it {is_expected.to be_able_to(:show, ProjectPrototype)}
      end

      describe "dictionaries" do
        it {is_expected.to be_able_to(:update, Dictionary)}
      end

      describe "daily_currencies" do
        it {is_expected.to be_able_to(:create, DailyCurrency)}
        it {is_expected.to be_able_to(:update, DailyCurrency)}
      end

      describe "shippings" do
        it {is_expected.to be_able_to(:create, Shipping)}
      end

      describe "structure elements" do
        it {is_expected.to be_able_to(:new, Shipping)}
      end

      describe "resources" do
        it {is_expected.to be_able_to(:create, Resource)}
        it {is_expected.to be_able_to(:update, Resource)}
      end

      describe "words" do
        it {is_expected.to be_able_to(:create, Word)}
        it {is_expected.to be_able_to(:update, Word)}
      end
    end
  end

end
