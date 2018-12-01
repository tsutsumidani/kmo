# CSVインポート情報に関するコントローラー
class CsvImportController < AfterAuthController
  # before_action
  before_action :set_object
  before_action :set_client_list

  # 初期表示
  def index
    if !flash[:valid].blank?
      @valid = flash[:valid]
    end
  end

  # CSV読込のロジック
  #
  # [tpl] index.html.erb
  # [js] none
  def import
    # CSV読込データ
    csv_file = params['file']
    client_id = params['client']['id']

    # ログインユーザの情報を取得
    user = MUser.find(@user_id)
    company_id = user.m_company_id

    # クライアントデータバリデーション
    count = MClient.where(id: client_id, m_company_id: company_id).size
    if count == 0 then
      raise
    end

    # csv取り込みデータバリデーション
    @valid = valid(csv_file)
    if @valid[:isError] then
      flash[:valid] = @valid
      redirect_to action: 'index'
#      render action: :index
      return
    end

    # CSVデータの取込
    begin
      @csv_import_service.import_to_work_table(csv_file, client_id)
      @message = '取り込みが正常に完了しました'
    rescue => ex
      @message = '取り込み時にエラーが発生しました。取り込みファイルを確認してください。'
      puts ex
    end

    # 取込んだデータを取得する
    uncheck_data = @csv_import_service.suggest_uncheck_data(client_id)

    # 修正サジェスト候補の抽出
    suggests = @suggest_message_service.suggest_data(uncheck_data)

    # 抽出データを仕訳-メッセージテーブルに保存
    @suggest_message_service.insert_journal_messages(suggests, client_id)

    # 仕訳データをサジェスト確認済に変更して保存
    @suggest_message_service.update_to_suggest_confirmed(uncheck_data)

    render action: :index
  end

  private
  # バリデーション
  #
  # @param [array] csv_file CSVデータ.
  # @return [array] バリデーションエラーの詳細.
  def valid(csv_file)
    validResult = {}
    validResult[:isError] = true
    # ファイル存在チェック
    if csv_file.blank? then
      validResult[:type] = "no_file"
      return validResult
    end

    # ファイル形式チェック
    if File.extname(csv_file.original_filename) != '.csv' then
      validResult[:type] = "file_format"
      return validResult
    end

    # データフォーマットチェック
    data_errors = @csv_import_service.data_valid(csv_file)
    if !data_errors.empty? then
      validResult[:type] = "data_format"
      validResult[:errors] = data_errors
      return validResult
    end

    # エラー無しとして返す
    validResult[:isError] = false
    return validResult
  end

  # コンストラクタ
  def set_object
    @csv_import_service = CsvImportService.new
    @suggest_message_service = SuggestMessageService.new
  end

  # クライアントリスト初期表示
  def set_client_list
    # ユーザの会社ID情報の取得
    company_id = MUser.where(id: @user_id).select(:m_company_id)
    # クライアント情報の取得
    clients = MClient.where(m_company_id: company_id).select(:id, :client_nm)
    @clients = {}
    clients.each do |client|
      @clients[client.client_nm] = client.id
    end
  end
end
