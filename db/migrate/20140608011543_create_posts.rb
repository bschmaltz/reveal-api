class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content, :username
      t.boolean :revealed

      t.timestamps
    end
  end
end
