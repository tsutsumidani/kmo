class SignUpController < ApplicationController

  # 登録処理
  # @redirect ホーム画面.
  def register
    # 取得した値をuserにセット
    user = MUser.new
    user.first_nm = params[:first_nm]
    user.last_nm = params[:last_nm]
    user.mail_address = params[:email]
    user.password = params[:password]

    # エラーが発生した場合
    if (user.valid?) then
      return false
    end

    # 登録
    user.save

    redirect_to controller: 'home' , action: 'index'
    return
  end
end
