# frozen_string_literal: true

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
class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :credentials, dependent: :destroy

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true

  normalizes :username, with: ->(username) { username.to_s.strip }

  after_initialize do
    self.webauthn_id ||= ::WebAuthn.generate_user_id
  end
end
