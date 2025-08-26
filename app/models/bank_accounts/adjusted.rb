# frozen_string_literal: true

class BankAccounts::Adjusted < ApplicationEvent
  MANDATORY_KEYS = %i[ amount_cents kind description ].freeze
end
