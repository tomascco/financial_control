class CreateCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :credentials do |t|
      t.string :external_id
      t.string :public_key
      t.string :nickname
      t.string :sign_count
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :credentials, :external_id, unique: true
  end
end
