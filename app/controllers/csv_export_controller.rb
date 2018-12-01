class CsvExportController < AfterAuthController
  # before_action
  before_action :set_object

  # 初期表示
  def index
    # クライアントリスト取得
    @csv_export_form.client_list = @csv_export_service.get_client_list(@user_id)

    # 先頭のクライアントの仕訳データ期間リストを取得
    @csv_export_form.period_list = @csv_export_service.get_journal_period(@csv_export_form.client_list)
  end

  # CSV出力処理
  def export
    client_id = params['client_id']
    @tJournals = TJournal.where(m_client_id: client_id, delete_flg: 1)
    logger.debug 'ログ出力'
    logger.debug @tJournals.inspect
 end

  # クライアント仕訳情報の出力可能な期間情報を取得
  def get_period
  end

  private
  # コンストラクタ
  def set_object
    @csv_export_form = CsvExportForm.new
    @csv_export_service = CsvExportService.new
  end
end
