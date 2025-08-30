# frozen_string_literal: true

module Transactions
  class Creation < Solid::Process
    deps do
      attribute :bank_account_repository, default: ::BankAccounts::Repository.new
      attribute :event_store, default: Rails.configuration.event_store
    end

    input do
      attribute :user_id
      attribute :from_bank_account_id
      attribute :to_bank_account_id

      attribute :amount_cents, :integer
      attribute :description, :string
    end

    def call(attributes)
      Given(attributes)
        .and_then(:fetch_bank_accounts)
        .and_then(:publish_transaction)
    end

    private

    def fetch_bank_accounts(user_id:, from_bank_account_id:, to_bank_account_id:, **)
      from_bank_account, to_bank_account = BankAccounts::Record
        .where(user_id:, id: [ from_bank_account_id, to_bank_account_id ])

      return Failure(:bank_accounts_not_found) if from_bank_account.nil? || to_bank_account.nil?

      Continue(from_bank_account:, to_bank_account:)
    end

    def publish_transaction(amount_cents:, description:, user_id:, from_bank_account:, to_bank_account:, **)
      transaction_id = SecureRandom.uuid

      deps.bank_account_repository.with_bank_account(from_bank_account) do |balance|
        balance.publish_expense!(amount_cents:, description:, transaction_id:)
      end

      deps.bank_account_repository.with_bank_account(to_bank_account) do |balance|
        balance.publish_income(amount_cents:, description:, transaction_id:)
      end

      event = Users::TransactionCreated.new(data: { amount_cents:, transaction_id: })
      deps.event_store.publish(event, stream_name: "User$#{user_id}")

      Success(:transaction_published, transaction_id:)
    rescue ::BankAccounts::Balance::InsufficientFundsError
      Failure(:insufficient_funds)
    end
  end
end
