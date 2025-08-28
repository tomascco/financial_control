# frozen_string_literal: true

module BankAccounts
  module InitializeCurrentMonth
    def self.call
      client = Rails.configuration.event_store

      BankAccounts::Record.find_each do |bank_account|
        account_balance =
          RailsEventStore::Projection
            .from_stream(bank_account.main_stream_name)
            .init(-> { { amount_cents: 0 } })
            .when(BankAccounts::Credited, ->(state, event) { state[:amount_cents] += event.data[:amount_cents] })
            .when(BankAccounts::Debited, ->(state, event) { state[:amount_cents] -= event.data[:amount_cents] })
            .run(client)

        event = BalanceInitialized.new(data: { amount_cents: account_balance[:amount_cents] })
        client.publish(event, stream_name: bank_account.current_month_stream_name)
      end
    end
  end
end
