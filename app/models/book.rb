require 'csv'
require 'json'

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
		self.json_file_path = get_file_path_json
		parse_into_csv
	end

	def get_raw_file_path
		"#{Rails.root}/public/#{self.title.parameterize}.txt"
	end

	def get_parsed_file_path
		"#{Rails.root}/public/p-#{self.title.parameterize}.txt"
	end

	def get_file_path_json
		"json-#{self.title.parameterize}.json"
	end

	def get_file_path_json_full
		"#{Rails.root}/public/json-#{self.title.parameterize}.json"
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

	def self.get_highest_level_book
		Book.where('reading_level=?',Book.maximum('reading_level')).first
	end

	def self.get_most_words_book
		Book.where('word_count=?', Book.maximum('word_count')).first
	end

	def self.get_highest_word_length_book
		Book.where('avg_word_length=?', Book.maximum('avg_word_length')).first
	end

	def self.get_most_syllable_book
		Book.where('avg_syllable_length=?', Book.maximum('avg_syllable_length')).first
	end

	def self.get_longest_sentences_book
		Book.where('avg_sentence_length=?', Book.maximum('avg_sentence_length')).first
	end

	def parse_into_csv
	  stop_words = ["i", "the", "a", "about", "above", "above", "across", "-", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount", "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as", "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]
	  File.open(self.raw_file_path) do |t|
	    # array of words
	    words = t.read.downcase.gsub(/[,.\/!@#$%^&*()_1234567890\[\]|'":;<>?`~+=]/, "").split(" ")

	    # chunked_words == [[word,# of occurences],[word,# of occurences]...] in desc order of occurences
	    chunked_words = []
	    words.sort.chunk {|word| word }.each {|word, chunk| chunked_words << [word, chunk.length]}
	    chunked_words.sort_by! {|chunk| chunk[1] }
	    chunked_words = chunked_words.sort {|x,y| y[1] <=> x[1]}

	    # put chunks into csv file
		json_array = []
		json_chunks = []	   
	    CSV.open(self.parsed_file_path, "w", write_headers: true, headers: ["name", "count"]) do |csv|
	      chunked_words.each do |chunk|
	        csv << chunk
	        json_chunks  = {name: chunk[0], size: chunk[1]} 
	        json_array << json_chunks unless stop_words.include? json_chunks[:name]      
	    end
	      	# saves json_array to json file
	      	json_array = json_array.first(30)
        	File.open(self.get_file_path_json_full,"w") do |f|
       		f.write('{ "children": ')
        	f.write(json_array.to_json)
        	f.write("}")
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
