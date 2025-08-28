# == Schema Information
#
# Table name: bank_accounts
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#  user_id    :bigint           not null
#
# Indexes
#
#  index_bank_accounts_on_user_id           (user_id)
#  index_bank_accounts_on_user_id_and_name  (user_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class BankAccounts::Record < ApplicationRecord
  self.table_name = "bank_accounts"

  default_scope { where(deleted_at: nil) }

  belongs_to :user

  def current_month_stream_name
    time = Time.current
    "BankAccount$#{id}-#{time.year}-#{time.month.to_s.rjust(2, '0')}"
  end

  def main_stream_name
    "BankAccount$#{id}"
  end
end
