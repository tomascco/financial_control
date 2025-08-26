# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Transactions

- Transfer
  - debits one account and credits another
- Expenses
  - debits one account
- Incomes
  - credits one account

## Events
- Transfer
  - TransferSent(amount_cents, notes)
  - TransferCancelled(amount_cents, notes)
  - TransferChanged(amount_cents, notes)
- Expense
  - ExpenseCreated(amount_cents, notes)
  - ExpenseCancelled(amount_cents, notes)
  - ExpenseChanged(amount_cents, notes)
- Income
  - IncomeCreated(amount_cents, notes)
  - IncomeCancelled(amount_cents, notes)
  - IncomeChanged(amount_cents, notes)

## v2

- TransactionCommited(amount_cents, notes)
- AccountCredited(amount_cents, notes, transaction_id)
- AccountDebited(amount_cents, notes, transaction_id)
- AccountAdjusted(amount_cents, notes)

"00000000-0000-0000-0000-000000000000"
