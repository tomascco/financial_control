# frozen_string_literal: true

module BankAccounts
  class BalanceInitialized < ApplicationEvent
    MANDATORY_KEYS = %i[ amount_cents ].freeze
  end
end
