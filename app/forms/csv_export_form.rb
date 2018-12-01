# CSVエクスポート画面に関するフォーム
class CsvExportForm
  include ActiveModel::Model
  attr_accessor :client_list, :period_list
end