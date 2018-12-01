require 'csv'
require 'kconv'
require 'date'

# CSVインポート画面に関するビジネスロジックを纏めたクラス<br>
class CsvImportService

  # CSVから取得したデータを元にDBにレコードを追加する
  #
  #  @param [array] csv_data CSV読込データ.
  #  @param [int] client_id クライアントID.
  def import_to_work_table(csv_data, client_id)
    # csvファイルを受け取って文字列にする
    csv_text = csv_data.read
    #文字列をUTF-8に変換
    CSV.parse(Kconv.toutf8(csv_text)) do |row|
      # 勘定テーブル
      t_journal = TJournal.new
      # 会社ID
      t_journal.m_client_id = client_id
      # # 日付
      t_journal.record_dt = row[1]
      # 借方勘定科目
      t_journal.debit_nm = row[2]
      # 借方金額
      t_journal.debit_amount = row[3]
      # 貸方摘要欄
      t_journal.debit_detail = row[4]
      # 貸方勘定項目
      t_journal.credit_nm = row[5]
      # 貸方金額
      t_journal.credit_amount = row[6]
      # 貸方摘要欄
      t_journal.credit_detail = row[7]
      # サジェスト確認済フラグ
      t_journal.suggest_confirm_flg = 0
      # DBに保存
      t_journal.save
    end
  end

  # 投入データのバリデーション
  #
  # @param [array] csv_data CSVデータ.
  # @return [array] バリデーションエラーの詳細.
  def data_valid(csv_data)
    # エラーデータを格納するマップ
    errors = []

    # 取得したCSVデータをUTF-8に変換し、一行ずつ処理
    csv_text = csv_data.read
    CSV.parse(Kconv.toutf8(csv_text)) do |row|
      # エラーになったカラム番号格納用マップ
      column = []

      # 登録日：日付のチェック(必須、フォーマット)
      if row[1].nil? || !date_valid(row[1]) then
        column.push(1)
      end

      # 借方勘定項目：項目名のチェック（必須、桁数）
      if row[2].nil? || row[2].length > 100 then
        column.push(2)
      end

      # 借方金額：金額のチェック(必須、整数値、桁数）
      if row[3].nil? || !(row[3] !=~ /^[0-9]+$/) || row[3].to_s.length > 10 then
        column.push(3)
      end

      # 借方摘要欄：記載内容のチェック（桁数）
      if !row[4].nil? && row[4].length > 500 then
        column.push(4)
      end

      # 貸方勘定項目：項目名のチェック（必須、桁数）
      if row[5].nil? || row[5].length > 100 then
        column.push(5)
      end

      # 貸方金額：金額のチェック(必須、整数値、桁数）
      if row[6].nil? || !(row[6] =~ /^[0-9]+$/) || row[6].to_s.length > 10 then
        column.push(6)
      end

      # 貸方摘要欄：記載内容のチェック（桁数）
      if !row[7].nil? && row[7].length > 500 then
        column.push(7)
      end

      # カラムいずれか1つでもエラーが存在した場合は結果データを格納
      if !column.empty? then
        error = {
          "column" => column,
          "data" => row
        }
        errors.push(error)
      end
    end

    return errors
  end

  # 修正サジェストデータの抽出
  #
  # @param [int] client_id クライアントID.
  # @return [array] 抽出データ.
  def suggest_uncheck_data(client_id)
    return TJournal.where(m_client_id: client_id, delete_flg: 0, suggest_confirm_flg: 0)
  end

  private
  # 日付形式のチェック
  #
  # @param [date] input_date 入力された日付.
  # @return [bool] バリデーションエラーなし:true, あり:false.
  def date_valid(input_date)
    !! Date.parse(input_date) rescue false
  end
end