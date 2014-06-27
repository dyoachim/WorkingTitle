require 'csv'

class Book < ActiveRecord::Base
	has_many :votes
	has_many :comments
	belongs_to :user

	before_save :init

	def init
		self.raw_file_path = get_raw_file_path
		self.parsed_file_path = get_parsed_file_path
		self.word_count = get_word_count
		self.avg_sentence_length = get_avg_sentence_length
		self.avg_syllable_length = get_avg_syllable_length
		self.avg_word_length = get_avg_word_length
		self.reading_level = get_reading_level
	end

	def get_raw_file_path
		"#{Rails.root}/public/#{self.title.parameterize}.txt"
	end

	def get_parsed_file_path
		"#{Rails.root}/public/p-#{self.title.parameterize}.txt"
	end

	def get_word_count
	  File.open(self.raw_file_path) do |t|
	    t.read.downcase.gsub(/[,.\/!@#$%^&*()_1234567890\[\]|'":;<>?`~+=]/, "").split(" ").length
	  end
	end

	def get_avg_sentence_length
	  File.open(self.raw_file_path) do |t|
	    # split sentences into an array of words
	    sentences = []
	    t.read.gsub(/[\/!@#$%^&*()1234567890\[\]|'":;<>?`~+=-]/, "").split(".").each do |sentence|
	      sentences << sentence.split(" ")
	    end
	    sentences.inject(0.0) { |sentence_length_sum, sentence_array| sentence_length_sum + sentence_array.length} / sentences.length
	  end
	end

	def get_avg_word_length
	  File.open(self.raw_file_path) do |t|
	    text = t.read.gsub(/[,.\/!@#$%^&*()1234567890\[\]|'":;<>?`~+=-]/, "")
	    (text.chars.reject{|char| [" "].include?(char)}.length).to_f / text.split(" ").length
	  end
	end

	def get_avg_syllable_length
	  File.open(self.raw_file_path) do |t|
	    words = t.read.downcase.gsub(/[,.\/!@#$%^&*()_1234567890\[\]|'":;<>?`~+=]/, "").split(" ").reject {|word| ["a","the","to","he",'of', 'his', 'was', 'in', 'it', 'had', 'that', 'and', 'as', 'with', 'she', 'not', 'for', 'him', 'would', 'at', 'but', 'on', 'they', 'all', 'this', 'be', 'from', 'if', 'or', 'could', 'have', 'so', '-', 'by', 'than', 'which','an', 'is'].include?(word)}
	    words.inject(0.0) {|syllable_sum, word| syllable_sum + word.syllable_count } / words.length
	  end
	end

	def get_reading_level
	    (((self.avg_sentence_length * 0.39) + (self.avg_syllable_length * 11.8)) - 15.59).floor(2)
	end

	def parse_into_csv
	  File.open(self.raw_file_path) do |t|
	    # array of words
	    words = t.read.downcase.gsub(/[,.\/!@#$%^&*()_1234567890\[\]|'":;<>?`~+=]/, "").split(" ")

	    # chunked_words == [[word,# of occurences],[word,# of occurences]...] in desc order of occurences
	    chunked_words = []
	    words.sort.chunk {|word| word }.each {|word, chunk| chunked_words << [word, chunk.length]}
	    chunked_words.sort_by! {|chunk| chunk[1] }
	    chunked_words = chunked_words.sort {|x,y| y[1] <=> x[1]}

	    # put chunks into csv file
	    CSV.open(self.parsed_file_path, "w", write_headers: true, headers: ["name", "count"]) do |csv|
	      chunked_words.each do |chunk|
	        csv << chunk
	      end
	    end
	  end
	end

	def self.search(query)
	  if query
	    where('title LIKE ? OR author LIKE ?', "%#{query["search"]}%", "%#{query["search"]}%")
		end
	end
end