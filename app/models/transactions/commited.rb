# frozen_string_literal: true

class Transactions::Committed < ApplicationEvent
  MANDATORY_KEYS = %i[amount_cents transaction_id from_user_id to_user_id].freeze
end
