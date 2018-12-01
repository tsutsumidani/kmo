# 個々のクライアント企業画面に関するコントローラー
class ClientInfoController < AfterAuthController

  # before_action
  before_action :set_object

  # 初期表示
  def index
    # パラメータから会社IDを取得
    client_id = params['client_id']

    # 取得した会社IDがユーザの顧客であるかを確認
    if !@client_info_service.is_users_client(@user_id, client_id)
      raise "invalid company is searched. user_id is #{user_id}"
    end

    @client_info_form.client = MClient.find_by(id: client_id)

    # jsに渡すクライアント情報をgonにセット
    gon.client = @client_info_form.client

    # 会社IDと現在の年から会計情報を取得しgonにセット
    # journals = @company_info.get_journal(client_id, Time.now.year)
    gon.journal_list = @client_info_service.get_journal(client_id)

    # メッセージと紐づく会計情報を取得
    @messages = @suggest_message_service.get_suggest_list_for_company(client_id)
  end

  private
  # コンストラクタ
  def set_object
    @client_info_form = ClientInfoForm.new
    @client_info_service = ClientInfoService.new
    @suggest_message_service = SuggestMessageService.new
  end
end
