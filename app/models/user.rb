# frozen_string_literal: true

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
