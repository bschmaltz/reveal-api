class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id, :watch_stat, :ignore_stat, :share_stat
      t.string :content
      t.boolean :revealed
      t.float :latitude, :longitude

      t.timestamps
    end
  end
end
