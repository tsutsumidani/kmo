require 'date'

# ログイン後の画面に共通するビジネスロジックを纏めたクラス
class AfterAuthService

  # 対応期間毎に分類した修正サジェストメッセージ件数取得
  #
  # @param [int] user_id ユーザID.
  # @return [array] サジェストメッセージ件数情報.
  def get_suggest_message_counts(user_id)
    # ユーザの所属企業ID取得
    company_id = MCompany.joins(:m_users).where(m_users: {id: user_id}).select("id")
    # クライアントIDリスト取得
    client_ids = MClient.where(m_company_id: company_id).select("id")
    # ユーザがもつサジェストメッセージを取得
    t_journal_messages = TJournalMessage.select(:due_dt).where(m_client_id: client_ids)

    # 取得したサジェストメッセージの期限をカウントする
    one_month = 0
    three_month = 0
    half_year = 0
    year = 0
    t_journal_messages.each do |t_journal_message|
      date = t_journal_message.due_dt

      if Date.today.next_month(1)  >= date then
        # 期限が1ヶ月以内
        one_month += 1
      elsif Date.today.next_month(3) >= date then
        # 期間が3ヶ月以内
        three_month += 1
      elsif Date.today.next_month(6) >= date then
        # 期間が半年以内
        half_year += 1
      elsif Date.today.next_year(1) >= date then
        # 期間が1年以内
        year += 1
      end
    end

    all = one_month + three_month + half_year + year
    result =  {
      "one_month": one_month != 0 ? one_month*100/all : one_month,
      "three_month": three_month != 0 ? three_month*100/all : three_month,
      "half_year": half_year != 0 ? half_year*100/all : half_year,
      "year":year
    }
    return result
  end
end