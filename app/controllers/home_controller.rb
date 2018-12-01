# ホーム画面関連コントローラー
class HomeController < AfterAuthController
  # before_action
  before_action :set_object

  # 画面遷移時のロジック
  #
  # [tpl] index.html.erb
  # [js] home.js
  def index
    # 顧客情報取得
    company = MCompany.joins(:m_users).where(m_users: {id: @user_id})
    # クライアントリスト取得
    @home_form.client_list = MClient.where(m_company_id: company)
    # 仕訳データ取得
    @home_form.journal_list = @home_service.getTJournal(company)

    # 画面にグラフ用データを渡す
    gon.client_list = @home_form.client_list
    gon.journal_list = @home_form.journal_list
  end

  # コンストラクタ
  private
  def set_object
    @home_form = HomeForm.new
    @home_service = HomeService.new
  end
end
