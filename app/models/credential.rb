# frozen_string_literal: true

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
class Credential < ApplicationRecord
  belongs_to :user, class_name: "Users::Record", foreign_key: :user_id
end
