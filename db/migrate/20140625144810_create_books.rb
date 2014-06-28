class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
    	t.integer :user_id, :word_count
    	t.decimal  :reading_level, :avg_sentence_length, :avg_syllable_length, :avg_word_length
    	t.string :title, :author, :raw_file_path, :parsed_file_path, :json_file_path
      t.timestamps
    end
  end
end

# avg_sentence_length by # of words
# avg_syllable_length of a word