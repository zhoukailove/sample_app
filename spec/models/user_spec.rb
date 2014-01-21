require 'spec_helper'

describe User do
  before do
    @user = User.new(name: "Rails",
                     email: "user@Rails.com",
                     password:"foobar",
                     password_confirmation: "foobar")

  end

  subject { @user } #把 @user 设为这些测试用例默认的测试对象

  #两个测试用例对 name 和 email 属性的存在性进行了测试
  # Ruby 的 respond_to? 方法，这个方法可以接受一个 Symbol 参数，
  # 如果对象可以响应指定的方法或属性就返回 true，否则返回 false
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name="" }
    it { should_not be_valid }

    #it "should be valid" do
    #  expect(@user).to be_valid
    #end
  end

  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a"*15 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |address|
        @user.email = address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new( name:"Rails",
                        email:"Rails@zu.com",
                        password:"",
                        password_confirmation:"")
    end
    it { should_not be_valid }

  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate mathod" do
    before {@user.save}
    # RSpec 提供的 let 方法便捷的在测试中定义局部变量
    # let 方法的句法看起来有点怪，不过和变量赋值语句的作用是一样的。
    # let 方法的参数是一个 Symbol，后面可以跟着一个块，块中代码的返回值会赋给名为 Symbol 代表的局部变
    let(:found_user) {User.find_by(email: @user.email)}

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password)}
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end

    describe "remember token" do
      before { @user.save }
      its(:remember_token) { should_not be_blank }
      #it { expect(@user.remember_token).not_to be_blank }

    end

  end


  pending "add some examples to (or delete) #{__FILE__}"
end
