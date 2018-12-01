# CSVインポート画面に関するフォーム
class CsvImportForm
  include ActiveModel::Model
  attr_accessor :csv_file, :client_id

end