class CreateBankAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :bank_accounts, [ :user_id, :name ], unique: true
  end
end
