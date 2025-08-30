# frozen_string_literal: true

module BankAccounts
  class Balance
    include AggregateRoot

    attr_reader :balance_cents

    class InsufficientFundsError < StandardError; end

    def initialize
      @balance_cents = 0
    end

    def publish_expense!(amount_cents:, description:, transaction_id:)
      raise InsufficientFundsError if @balance_cents < amount_cents

      apply Debited.new(data: { amount_cents:, description:, transaction_id: })
    end

    def publish_income(amount_cents:, description:, transaction_id:)
      apply Credited.new(data: { amount_cents:, description:, transaction_id: })
    end

    on Credited do |event|
      @balance_cents += event.data[:amount_cents]
    end

    on Debited do |event|
      @balance_cents -= event.data[:amount_cents]
    end
  end
end
