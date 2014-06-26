class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
    	t.integer :commenter_id, :book_id
    	t.text :comment_text

      t.timestamps
    end
  end
end
