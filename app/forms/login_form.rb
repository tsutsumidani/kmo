# ログイン画面用フォームオブジェクト
class LoginForm
  include ActiveModel::Model
  attr_accessor :mail_address, :password

  validates :address, :password, presence: true
end