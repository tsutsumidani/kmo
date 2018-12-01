class MMessage < ApplicationRecord
  # relation
  has_many :t_journals, through: :t_journal_messages
  has_many :t_journal_messages
end
