# ユーザーのホーム画面に関するビジネスロジックを纏めたクラス
class HomeService

  # 修正中仕訳データ
  #
  # @param [int] company_id 企業ID.
  # @return [Array] 仕訳データ.
  def getTJournal(company_id)
    # 所属会社のクライアントIDを取得
    client_ids = MClient.where(m_company_id: company_id).select("id")

    # クライアント全ての仕訳データを取得
    return TJournal.where(m_client_id: client_ids, delete_flg: 0).group(:record_dt, :m_client_id)
        .select("m_client_id, sum(debit_amount) as debit_amount, sum(credit_amount) as credit_amount, DATE_FORMAT(record_dt,'%Y/%m') as f_record_dt")
  end
end
