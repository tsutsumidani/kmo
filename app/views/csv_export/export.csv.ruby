require 'csv'

CSV.generate do |csv|
  csv_column_names = %(Firstname Lastname Email)
  csv << csv_column_names
  @tJournal.each do |user|
    csv_column_values = [
      tJournal.debit_nm,
      tJournal.debit_amount
      tJournal.credit_nm
    ]
    csv << csv_column_values
  end
end
