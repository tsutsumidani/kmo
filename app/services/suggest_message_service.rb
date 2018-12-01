class SuggestMessageService

  # CSVから取得したデータからサジェスト対象データを抽出する.
  #
  #  @param [array] objs 登録された仕訳データ.
  #  @return [map] メッセージIDと仕訳IDのマップ.
  def suggest_data(objs)
    results = []

    #文字列をUTF-8に変換
    objs.each do |obj|
      messages = []
      # 勘定科目が「消耗品」で金額が「30万円以上」の場合、メッセージID = 1
      if !obj.debit_accounts_nm["消耗品"].nil? && obj.debit_accounts_amount >= 300000 then
        messages.push(1)
      end

      # 「賞与」、「役員賞与」という勘定科目がある場合、メッセージ = 2
      if !obj.debit_accounts_nm["賞与"].nil? || !obj.debit_accounts_nm["役員賞与"].nil? then
        messages.push(2)
      end

      # 「受取配当金」という勘定科目がある場合、メッセージ = 3
      if !obj.debit_accounts_nm["受取配当金"].nil? then
        messages.push(3)
      end

      # 摘要欄に「軽油引取税」という文言がある場合、メッセージ = 4
      if !obj.debit_summary["経由取引税"].nil? then
        messages.push(4)
      end

      # 摘要欄または勘定科目に「リース」という文言がある場合やリース会社名がある場合、メッセージ = 5
      if !obj.debit_accounts_nm["リース"].nil? then
        messages.push(5)
      end

      # 摘要欄または勘定科目に「除却」という文言がある場合、メッセージ = 6
      if !obj.debit_accounts_nm["除却"].nil? || !obj.debit_summary["除却"].nil? then
        messages.push(6)
      end

      # 摘要欄に「HIS、海外、アメリカ、US」という文言があり、また、勘定科目が「旅費交通費」の場合、メッセージ = 7
      if (obj.debit_summary["HIS"] || obj.debit_summary["海外"] || obj.debit_summary["アメリカ"] || obj.debit_summary["US"]) && !obj.debit_accounts_nm["旅費交通費"].nil? then
        messages.push(7)
      end

      result = {
        :j_num => obj.id,
        :m => messages
      }

      results.push(result)
    end

    return results
  end

  # 仕訳-メッセージテーブルへのデータ登録
  #
  # @param [array] suggests サジェスト投入データ.
  # @param [int] client_id クライアントID.
  # @return [array] バリデーションエラーの詳細.
  def insert_journal_messages(suggests, client_id)
    t_journal_message = TJournalMessage.new
    suggests.each do |suggest|
      suggest[:m].each do |m|
        t_journal_message.t_journal_id = suggest[:j_num]
        t_journal_message.m_message_id = m
        t_journal_message.m_client_id = client_id
        t_journal_message.save
      end
    end
  end

  # 仕訳データをサジェスト確認済みに変更して更新
  #
  # @param [array] uncheck_data サジェスト確認用取得データ.
  def update_to_suggest_confirmed(uncheck_data)
    uncheck_data.each do |ud|
      ud.update_attribute(:delete_flg, 1)
    end
  end

  # メッセージとメッセージをクリックした時のモーダルに表示される会計情報をセットで取得
  # 一企業毎のデータ
  #
  # @param [int] client_id クライアントID.
  # @return [array] メッセージと会計情報を格納した連想配列
  def get_suggest_list_for_company(client_id)
    # メッセージの取得(メッセージと一緒に表示する日付は、重複するメッセージの中で最新のものを取得)
    messages = MMessage.joins(:t_journal_messages).select("m_messages.*, MAX(t_journal_messages.created_at) as max_created_at")
                  .where(t_journal_messages: {m_client_id: client_id, delete_flg: 0}, m_messages: {delete_flg: 0}).group("m_messages.id")

    # 会計情報の取得
    journals = TJournal.joins(:t_journal_messages)
                  .select("t_journals.*, t_journal_messages.id AS journal_message_id, t_journal_messages.m_message_id")
                  .where(t_journal_messages: {m_client_id: client_id, delete_flg: 0})

    # メッセージと紐づく会計情報をリストにセットする
    return unite_suggest_messages(messages, journals)
  end

  # メッセージとメッセージをクリックした時のモーダルに表示される会計情報をセットで取得
  # ユーザの持つデータ全て
  #
  # @param [int] user_id ユーザID.
  # @return [array] メッセージと会計情報を格納した連想配列
  def get_suggest_list_all(user_id)
    # ユーザに紐付く会社の会社IDを全件取得
    company_id = MCompany.joins(:m_users).select("m_companies.id").where(m_users: {id: user_id})

    # クライアントID取得
    client_ids = MClient.where(:m_company_id => company_id)

    # メッセージの取得(メッセージと一緒に表示する日付は、重複するメッセージの中で最新のものを取得)
    messages = MMessage.joins(:t_journal_messages).select("m_messages.*, MAX(t_journal_messages.created_at) as max_created_at")
                  .where(t_journal_messages: {m_client_id: client_ids, delete_flg: 0}, m_messages: {delete_flg: 0}).group("m_messages.id")

    # 会計情報の取得
    journals = TJournal.joins(:t_journal_messages)
                  .select("t_journals.*, t_journal_messages.id AS journal_message_id, t_journal_messages.m_message_id")
                  .where(t_journal_messages: {m_client_id: client_ids, delete_flg: 0})

    # メッセージと紐づく会計情報をリストにセットする
    return unite_suggest_messages(messages, journals)
  end

  # メッセージと会計情報のレコードをセットにする関数.
  #
  # @param [array] messages メッセージリスト.
  # @param [array] journals 会計情報リスト.
  # @return [array] メッセージ-会計情報のセットリスト.
  def unite_suggest_messages(messages, journals)
    # メッセージと紐づく会計情報をリストにセットする
    result_list = []
    # メッセージ１つ１つに対する処理
    messages.each do |m|
      result = {}
      result[:message] = m
      m_id = m.id
      # 会計情報１つ１つに対する処理
      journal_list = []
      journals.each do |j|
        j_id = j.m_message_id
        # メッセージIDが等しい場合、リストに格納
        if (m_id == j_id) then
          journal_list.push(j)
        end
      end
      result[:journals] = journal_list
      result_list.push(result)
    end

    return result_list
  end
end
