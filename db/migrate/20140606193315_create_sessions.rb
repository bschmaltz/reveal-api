class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.belongs_to :user
      t.string :ip_address, :path
      t.timestamps
    end
  end
end
