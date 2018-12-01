# ログイン後共通処理コントローラー
class AfterAuthController < ApplicationController
  # before action
  before_action :check_login
  before_action :set_user
  before_action :get_message_list

  private
  # ログインチェック
  def check_login
    # 未ログインの場合はログイン画面にリダイレクト
    if session[:id].blank?
      redirect_to controller: 'login' , action: 'index'
      return
    end
  end

  # ユーザ情報のセット
  def set_user
    @user_id = session[:id]
    @user_nm = MUser.find(@user_id).last_nm
  end

  # 対応案件情報の取得
  def get_message_list
    # サジェストメッセージ件数取得
    after_auth_service = AfterAuthService.new
    @result = after_auth_service.get_suggest_message_counts(@user_id)
  end
end
