# Feature: Sign in
feature 'Sign in', :devise do

  # Scenario: User cannot sign in if not registered
  scenario 'user cannot sign in if not registered' do
    signin('test@example.com', 'please123')
    expect(page).to have_content("Invalid Email or password")
  end

  # Scenario: User can sign in with valid credentials

  scenario 'user can sign in with valid credentials' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    expect(page).to have_content("Signed in successfull")
  end

  # Scenario: User cannot sign in with wrong email
  scenario 'user cannot sign in with wrong email' do
    user = FactoryGirl.create(:user)
    signin('invalid@email.com', user.password)
    expect(page).to have_content("Invalid Email or password")
  end

  # Scenario: User cannot sign in with wrong password
  scenario 'user cannot sign in with wrong password' do
    user = FactoryGirl.create(:user)
    signin(user.email, 'invalidpass')
    expect(page).to have_content("Invalid Email or password")
  end

end
