class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
    	t.integer :voter_id, :book_id, :up_or_down
      t.timestamps
    end
  end
end
