# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  username    :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  webauthn_id :string
#
# Indexes
#
#  index_users_on_name      (name) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
