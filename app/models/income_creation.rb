# frozen_string_literal: true

class IncomeCreation < Solid::Process
  deps do
    attribute :bank_account_repository, default: ::BankAccounts::Repository.new
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

  def build_and_publish_event(amount_cents:, description:, bank_account:, **)
    null_uuid = "00000000-0000-0000-0000-000000000000"

    puts "?????"
    deps.bank_account_repository.with_bank_account(bank_account) do |balance|
      puts "help"
      balance.publish_income(amount_cents:, description:, transaction_id: null_uuid)
    end

    Success(:event_published)
  end
end
