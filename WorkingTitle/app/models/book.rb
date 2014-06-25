require 'CSV'

class Book < ActiveRecord::Base
	has_many :votes
	has_many :comments
	belongs_to :user

	def calculate_reading_level(avg_words_per_sentence, avg_syllables_in_words)
		((avg_words_per_sentence * 0.39) + (avg_syllables_in_words * 11.8)) - 15.59
	end

	def avg_sentence_length
		File.open(self.title) do |t|
			# split sentences into an array of words
			sentences = []
			t.read.gsub(/[\/!@#$%^&*()1234567890\[\]|'":;<>?`~+=-]/, "").split(".").each do |sentence|
				sentences << sentence.split(" ")
			end

			sentence_length_sum = 0
			sentences.each do |sentence_array|
				sentence_length_sum += sentence_array.length
			end
		  sentence_length_sum / sentences.length 
		end
	end

	def avg_word_length
		File.open(self.title) do |t|
			text = t.read.gsub(/[,.\/!@#$%^&*()1234567890\[\]|'":;<>?`~+=-]/, "")
			text.chars.length / text.split(" ").length
		end
	end

	def parse_into_csv
		File.open(self.title) do |t|
		  # array of words
			words = t.read.downcase.gsub(/[,.\/!@#$%^&*()_1234567890\[\]|'":;<>?`~+=]/, "").split(" ")
			
			# chunked_words == [[word,# of occurences],[word,# of occurences]...] in desc order of occurences
			chunked_words = []
			words.sort.chunk {|word| word }.each {|word, chunk| chunked_words << [word, chunk.length]}
			chunked_words.sort_by! {|chunk| chunk[1] }
			chunked_words = chunked_words.sort {|x,y| y[1] <=> x[1]}

			# put chunks into csv file
			CSV.open("test.csv", "w") do |csv|
				chunked_words.each do |chunk|
					csv << chunk
				end
			end
		end

	def self.search(search)
	  if search
	    find(:all, conditions: ['title LIKE ?', "%#{search}%"])
	  else
	    find(:all)
	  end
	end
end



