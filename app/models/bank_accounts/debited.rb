# frozen_string_literal: true

class BankAccounts::Debited < ApplicationEvent
  MANDATORY_KEYS = %i[amount_cents description transaction_id].freeze
end
