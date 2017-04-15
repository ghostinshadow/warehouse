RSpec.shared_context "word activities", :shared_context => :metadata do
  def delete_word
    visit dictionary_words_path(@dictionary)
    click_link "Delete"
  end

  def create_word(word_body)
    visit dictionary_words_path(@dictionary)
    click_link "New word"
    fill_in('Body', :with => word_body)
    click_button "Create word"
  end

  def update_word(new_body)
    visit dictionary_words_path(@dictionary)
    click_link "Edit word"
    fill_in("Body", with: new_body)
    click_button "Update word"
  end
end

RSpec.shared_context "dictionary activities", :shared_context => :metadata do
  def update_dictionary(new_name)
    visit dictionaries_path
    click_link "Edit dictionary"
    fill_in("Title", with: new_name)
    click_button "Update dictionary"
  end
end

RSpec.shared_context "resource activities", :shared_context => :metadata do
  def create_dictionaries
    m = create(:materials_dictionary)
    n = create(:units_dictionary)
    [m, n]
  end

  def create_countable_resource
    create_resource do
      select('Countable', from: 'resource_type')
    end
  end

  def create_countless_resource
    create_resource do
      select('Countless', from: 'resource_type')
    end
  end

  def create_resource(&block)
    visit resources_path
    click_link "New resource"
    choose_name_category_unit(&block)
    fill_price
    click_button "Save resource"
  end

  def fill_price
    fill_in('resource_price_uah', with: '45.23')
    fill_in('resource_price_usd', with: '2.23')
    fill_in('resource_price_eur', with: '4.23')
  end

  def choose_name_category_unit
    select('metal', from: 'resource_name_id')
    wait_for_ajax
    select('5mm', from: 'resource_category_id')
    select('m2', from: 'resource_unit_id')
    yield
  end

  def update_resource(new_price)
    visit resources_path
    click_link "Edit resource"

    fill_in("resource_price_usd", with: new_price)

    click_button "Update resource"
  end
end

RSpec.shared_context "shipping activities", :shared_context => :metadata do
  def create_resources
    r1 = create(:countable_resource_bottom)
    r2 = create(:countable_resource)
    [r1, r2]
  end

  def create_shipping(name = 'shipping' ,&block)
    visit public_send("#{name}s_path")
    click_link "New #{name}"

    choose_date_and_type(&block)

    fill_prototype_name("87ui")

    fill_resource("metal", 5)

    fill_resource("bottom", 6.7)

    click_button "Save #{name}"
  end

  def fill_prototype_name(value)
    fill_in("project_prototype_name", with: value)
  end

  def fill_resource(option, value)
    @count ||= 1

    click_link "Add resource", visible: true
    wait_for_ajax
    select(option, from: "project_prototype_structure_resource_id_#{@count}")
    fill_in("project_prototype_structure_resource_name_#{@count}", with: value)
    @count += 1
  end

  def choose_date_and_type
    fill_in( 'shipping_shipping_date', with: '2017-03-27')
    yield if block_given?
  end

  def update_shipping(new_price)
    visit shippings_path
    click_link "Edit shipping"

    fill_in("shipping_price_usd", with: new_price)

    click_button "Update shipping"
  end

end

shared_examples_for "available resource" do |object|

  it "can show #{object}" do
    is_expected.to be_able_to(:show, object)
  end

  it "can new #{object}" do
    is_expected.to be_able_to(:new, object)
  end

  it "can index #{object}" do
    is_expected.to be_able_to(:index, object)
  end
end

shared_examples_for "admin resource" do |object, klass_name|

  it "should be particular resource" do
    expect(object.resource_name).to eq(klass_name)
  end

  it "should be included in menu" do
    expect(object).to be_include_in_menu
  end

end