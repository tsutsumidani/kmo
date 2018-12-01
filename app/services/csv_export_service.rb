# CSV出力機能に関するサービスロジッククラス
class CsvExportService
  # クライアントリスト取得
  # @param [int] user_id ユーザID.
  # @return [hash] クライアントリスト
  def get_client_list(user_id)
    # ユーザの会社ID情報の取得
    company_id = MUser.where(id: user_id).select(:m_company_id)
    # クライアント情報の取得
    clients = MClient.where(m_company_id: company_id).select(:id, :client_nm)
    client_list = {}
    clients.each do |client|
      client_list[client.client_nm] = client.id
    end

    return client_list
  end

  # 仕訳期間情報を取得
  # @param [int] client_id クライアントID.
  # @return [int] 
  def get_journal_period(client_list)
    first_client_id = 0
    client_list.each do |client|
      if first_client_id == 0
        first_client_id = client
        break
      end
    end

    journal_periods = TJournal.where(m_client_id: first_client_id).select(:record_dt)

    journal_list = []
    journal_periods.each do |journal_period|
      date = journal_period.record_dt.strftime("%Y/%m")
      journal_list.push(date)
    end

    return journal_list
  end
end