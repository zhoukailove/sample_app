module SessionsHelper
  #首先，创建新权标；
  # 随后，把未加密的权标存入浏览器的 cookie；
  # 然后，把加密后的权标存入数据库；
  # 最后，把制定的用户设为当前登入的用户
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  # 这段代码定义的 current_user= 方法是用来处理 current_user 赋值操作的
  # self.current_user = ...
  # 会自动转换成下面这种形式
  # current_user=(...)
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def signed_in?
    !current_user.nil?
  end
  # 先修改数据库中保存的记忆权标，以防 cookie 被窃取用来验证用户；
  # 然后在 cookies 上调用 delete 方法从 session 中删除记忆权标；
  # 最后一行代码是可选的，把当前用户设为 nil。（
  # 其实这里没必要把当前用户设为 nil，因为在 destroy 动作中我们加入了转向操作
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath if request.get?
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url,notice: "Please sign in."
    end
    #redirect_to signin_url,notice: "Please sign in." unless signed_in?
  end
end
