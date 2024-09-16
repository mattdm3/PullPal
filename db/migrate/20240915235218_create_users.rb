class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :github_token, null: false
      t.string :github_id, null: false
      t.string :name, null: false
      t.string :avatar_url, null: false
      # auto gen
      t.timestamps
    end

      # Add unique indexes
      add_index :users, :username, unique: true
      add_index :users, :email, unique: true
      add_index :users, :github_token, unique: true
  end
end
