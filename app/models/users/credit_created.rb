# frozen_string_literal: true

class Users::CreditCreated < ApplicationEvent
  MANDATORY_KEYS = %i[amount_cents transaction_id].freeze
end
