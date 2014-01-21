require 'spec_helper'

describe "AuthenticationPages" do

  subject { page }

  describe "singin page" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sing in" }

      #it { should have_content('Sign in') }
      #it { should have_title('Sign in') }
      #it { should have_selector('div.alert.alert-error') }
    end

    describe "after visiting another page" do
      before { click_link "Home" }
      it { should_not have_selector('div.alert.alert-error') }
    end

    describe "with valid information" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        fill_in 'Email',      with: user.email.upcase
        fill_in 'Password',   with: user.password
        click_button 'Sign in'
      end

      it { should have_title(user.name)}
      it { should have_link('Profile',  href: user_path(user))}
      #it { should have_link('Sign out', herf: signout_path)}
      it { should_not have_link('Sing in',href: signin_path)}

    end

  end

  #describe "GET /authentication_pages" do
  #  it "works! (now write some real specs)" do
  #    # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #    get authentication_pages_index_path
  #    response.status.should be(200)
  #  end
  #end
end
