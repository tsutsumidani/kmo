class LoginController < ApplicationController

  # ユーザログイン処理
  def search
    # フォーム初期化
    @login_form = LoginForm.new

    # 入力値
    @login_form.mail_address = params['address']
    @login_form.password = params['password']

    # 入力値チェック
    loginService = LoginService.new
    if !loginService.is_input_valid(@login_form)
      # 画面の入力チェックをパスして不正データが入力された場合は500エラー
      raise "invalid data was sent to the server. mail_address is {#{@login_form.mail_address}}, password is {#{@login_form.password}}."
    end

    # ユーザ情報取得
    user = MUser.find_by(mail_address: @login_form.mail_address)

    # ユーザ情報が取得できなかった場合エラー
    if user.nil?
      flash[:invalid_mail_address] = true
      redirect_to :action => 'index'
      return
    end

    # パスワードチェック
    if !user.authenticate(@login_form.password)
      flash[:invalid_password] = true
      redirect_to :action => 'index'
      return
    end

    # 取得したユーザのユーザIDをセッションに保存
    session[:id] = user.id

    # ホーム画面にリダイレクト
    redirect_to controller: 'home', action: 'index'
  end
end
