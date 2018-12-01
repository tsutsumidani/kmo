class LoginService

  # 入力値チェック
  #
  # @param [object] login_form
  # @return [bool] 正常:true/不正:false
  #
  def is_input_valid(login_form)
    # メールアドレス入力値チェック
    if !is_mail_address_valid(login_form.mail_address)
      return false
    end

    # パスワード入力値チェック
    if !is_password_valid(login_form.password)
      return false
    end

    return true
  end

  private
  # メールアドレス入力値チェック
  #
  # @param [String] mail_address
  # @return [bool] 正常:true/不正:false
  def is_mail_address_valid(mail_address)
    # 必須チェック、桁数(100)チェック
    if mail_address.blank? || mail_address.length > 100
      return false
    end

    # ToDo: メールアドレスフォーマットチェック実装

    return true
  end

  # パスワード入力値チェック
  #
  # @param [String] password
  # @return [bool] 正常:true/不正:false
  def is_password_valid(password)
    # 必須チェック、桁数チェック
    if password.blank? || password.length > 1000
      return false
    end

    # ToDo: パスワードフォーマットチェック実装

    return true
  end
end