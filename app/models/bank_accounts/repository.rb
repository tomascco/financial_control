# frozen_string_literal: true

module BankAccounts
  class Repository
    private attr_reader :repository, :event_store

    def initialize(event_store = Rails.configuration.event_store)
      @event_store = event_store
      @repository = ::AggregateRoot::Repository.new(event_store)
    end

    def with_bank_account(bank_account, &)
      subscriber = LinkToBankAccountAndUser.call(event_store, bank_account)

      event_store
        .within { repository.with_aggregate(Balance.new, bank_account.main_stream_name, &) }
        .subscribe(subscriber, to: [ Debited, Credited ])
        .call
    end

    LinkToBankAccountAndUser = ->(event_store, bank_account) do
      ->(event) { event_store.link(event.event_id, stream_name: bank_account.current_month_stream_name) }
    end
  end
end
