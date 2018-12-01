# ユーザ所属会社情報マスタ
class MCompany < ApplicationRecord
  # relation
  has_many :t_company_accounts
  has_many :t_journal_messages
  has_many :m_users
end
