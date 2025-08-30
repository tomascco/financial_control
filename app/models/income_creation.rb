# frozen_string_literal: true

class IncomeCreation < Solid::Process
  deps do
    attribute :bank_account_repository, default: ::BankAccounts::Repository.new
    attribute :event_store, default: Rails.configuration.event_store
  end

  input do
    attribute :amount_cents, :integer
    attribute :description, :string
    attribute :user_id
    attribute :bank_account_id
  end

  def call(attributes)
    Given(attributes)
      .and_then(:fetch_bank_account)
      .and_then(:build_and_publish_event)
  end

  private

  def fetch_bank_account(user_id:, bank_account_id:, **)
    bank_account = BankAccounts::Record.find_by(user_id:, id: bank_account_id)
    return Failure(:bank_account_not_found) if bank_account.nil?

    Continue(bank_account:)
  end

  def build_and_publish_event(amount_cents:, description:, user_id:, bank_account:, **)
    null_uuid = "00000000-0000-0000-0000-000000000000"

    deps.bank_account_repository.with_bank_account(bank_account) do |balance|
      balance.publish_income(amount_cents:, description:, transaction_id: null_uuid)
    end

    event = Users::CreditCreated.new(data: { amount_cents:, transaction_id: null_uuid })
    deps.event_store.publish(event, stream_name: "User$#{user_id}")

    Success(:event_published)
  end
end
