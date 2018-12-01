# ログアウトに関するAPIをまとめたクラス
class LogoutController < AfterAuthController

  # before_action
  before_action :set_object

  # 画面遷移時のロジック
  #
  # [tpl] logout.html.erb
  # [js] none
    def index
      # セッション情報を破棄する
      session.delete(:id)
  
      # ログイン画面にリダイレクト
      redirect_to controller: 'login' , action: 'index'
      return
    end
  
  # コンストラクタ
    private
    def set_object
      @home_service = HomeService.new
    end
  end