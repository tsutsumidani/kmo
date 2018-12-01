# 会計情報テーブル
class TJournal < ApplicationRecord
    # relation
    has_many :m_messages, through: :t_journal_messages
    has_many :t_journal_messages
end
