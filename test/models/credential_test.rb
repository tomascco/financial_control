# == Schema Information
#
# Table name: credentials
#
#  id          :bigint           not null, primary key
#  nickname    :string
#  public_key  :string
#  sign_count  :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string
#  user_id     :bigint           not null
#
# Indexes
#
#  index_credentials_on_external_id  (external_id) UNIQUE
#  index_credentials_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class CredentialTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
