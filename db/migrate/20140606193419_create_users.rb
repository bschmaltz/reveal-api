class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :salt, :encrypted_password, :auth_token
      t.timestamps
    end
  end
end
