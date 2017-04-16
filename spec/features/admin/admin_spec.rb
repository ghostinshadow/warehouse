describe "ActiveAdmin" do
  ADMIN_RESOURCES = ActiveAdmin.application.namespaces[:admin].resources

  def crud_actions
    [:create, :new, :update, :edit, :index, :show, :destroy]
  end

  describe "resources" do
    subject { ADMIN_RESOURCES.keys.map(&:route_key) }

    it "has User resource" do
      is_expected.to include("users")
    end

    it "has comment resource" do
      is_expected.to include("comments")
    end

    it "has dashboard resource" do
      is_expected.to include("dashboards")
    end

    it "has daily_currencies resource" do
      is_expected.to include("daily_currencies")
    end

    it "has resources" do
      is_expected.to include("resources")
    end
  end

  describe "User resource" do
    let(:resource_class) { User }
    let(:all_resources)  { ADMIN_RESOURCES }
    subject{ all_resources[resource_class] }

    it_behaves_like "admin resource", ADMIN_RESOURCES["User"], "User"

    it "has approve action" do
      expect(subject.member_actions.map(&:name)).to include(:approve)
    end

    it "has crud actions" do
      expect(subject.defined_actions).to include(*crud_actions)
    end

  end

  describe "Comment resource" do
    let(:resource_class) { 'Comment' }
    let(:all_resources)  { ADMIN_RESOURCES }
    subject{ all_resources[resource_class] }

    it_behaves_like "admin resource", ADMIN_RESOURCES["Comment"], "Comment"

    it "has crud actions" do
      expect(subject.defined_actions).to include(*[:create, :index, :destroy, :show])
    end

  end

  describe "DailyCurrency resource" do
    let(:resource_class) { 'DailyCurrency' }
    let(:all_resources)  { ADMIN_RESOURCES }
    subject{ all_resources[resource_class] }

    it_behaves_like "admin resource", ADMIN_RESOURCES["DailyCurrency"], "DailyCurrency"

    it "has crud actions" do
      expect(subject.defined_actions).to include(*crud_actions)
    end
  end

  describe "Resource resource" do
    let(:resource_class) { 'Resource' }
    let(:all_resources)  { ADMIN_RESOURCES }
    subject{ all_resources[resource_class] }

    it_behaves_like "admin resource", ADMIN_RESOURCES["Resource"], "Resource"

    it "has crud actions" do
      expect(subject.defined_actions).to include(*crud_actions)
    end
  end

# "Project","Dictionary","ProjectPrototype", "Shipping","Resource","Word"
end
