class ClientInfoService

  # ユーザのクライアントであるか
  #
  # @param [int] user_id.
  # @param [int] client_id  クライアントID.
  # @return [bool] ユーザのクライアント:true, ユーザのクライアントでない:false.
  def is_users_client(user_id, client_id)
    company_id = MCompany.joins(:m_users).where(m_users: {id: user_id}).select("id")
    count = MClient.where(id: client_id, m_company_id: company_id).count("id")
    return count > 0 ? true : false
  end

  # 仕訳データ取得.
  #
  # @param [int] client_id クライアントID.
  # @return [array] 仕訳データ
  def get_journal(client_id)
    # クライアント全ての仕訳データを取得
      return TJournal.where(m_client_id: client_id, delete_flg: 0).group(:record_dt, :m_client_id)
          .select("m_client_id, sum(debit_amount) as debit_amount, sum(credit_amount) as credit_amount, DATE_FORMAT(record_dt,'%Y/%m') as f_record_dt")
    end

  # journal_messageレコードがユーザのものであるかのチェックロジック
  #
  # @param [int] journal_message_id 仕訳-メッセージ中間テーブルID.
  # @param [int] user_id ユーザID.
  # @return [bool] 取得したIDのレコードがユーザのもの:true,それ以外の場合:false.
    def is_users_journal_message(journal_message_id, user_id)
      count = MCompany.joins(:t_journal_messages)
          .where(user_id: user_id, t_journal_messages: {id: journal_message_id}).count()
  
      # カウント0の場合は該当レコード無しのためfalse
      if count != 0 then
        return false
      end
  
      return true
    end

  # journal_messageレコードを確認済みに更新
  #
  # @param [int] journal_message_id 仕訳-メッセージ中間テーブルID.
    def update_tjournal_message_as_confirmed(journal_message_id)
      t_journal_message = TJournalMessage.find(journal_message_id)
      return t_journal_message.update_attribute(:delete_flg, 1)
    end
end
