# 会計メッセージ情報中間テーブル
class TJournalMessage < ApplicationRecord
  # relation
  belongs_to :t_journals
  belongs_to :m_messages
  belongs_to :m_companies
end
