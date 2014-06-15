class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id, :vote_stat, :share_stat
      t.string :username, :content
      t.boolean :revealed

      t.timestamps
    end
  end
end
