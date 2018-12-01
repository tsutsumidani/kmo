# クライアント画面関連フォームオブジェクト
class ClientInfoForm
  include ActiveModel::Model
  attr_accessor :client, :message_list
end
