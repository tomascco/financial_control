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
require "test_helper"

class BankAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
