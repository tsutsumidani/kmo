# ユーザ情報マスタ
class MUser < ApplicationRecord

  #relation
  belongs_to :m_companies, optional: true

  # validation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :mail_address, presence: true, format: { with: VALID_EMAIL_REGEX }
  # 登録時のみチェック（メールアドレス一意確認）
  validates :mail_address, presence: true, uniqueness: true, on: :create
  validates :first_nm, presence: true
  validates :last_nm, presence: true

  # has_secure_password
  has_secure_password
end
