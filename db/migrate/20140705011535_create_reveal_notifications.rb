class CreateRevealNotifications < ActiveRecord::Migration
  def change
    create_table :reveal_notifications do |t|
      t.integer :user_id
      t.integer :post_id
      t.boolean :viewed

      t.timestamps
    end
  end
end
