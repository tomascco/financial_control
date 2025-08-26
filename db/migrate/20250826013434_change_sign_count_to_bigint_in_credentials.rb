class ChangeSignCountToBigintInCredentials < ActiveRecord::Migration[8.0]
  def change
    change_column :credentials, :sign_count, :bigint, using: 'sign_count::bigint'
  end
end
