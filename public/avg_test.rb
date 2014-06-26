require "csv"

class String
  def syllable_count
    consonants = "bcdfghjklmnpqrstvwxz"
    vowels = "aeiouy"
    processed = self.downcase
    suffix_bonus = 0
    #puts "*** 0 #{processed}"
    if processed.match(/ly$/)
      suffix_bonus = 1
      processed.gsub!(/ly$/, "")
    end
    if processed.match(/[a-z]ed$/)
      # Not counting "ed" as an extra symbol. 
      # So 'blessed' is assumed to be said as 'blest'
      suffix_bonus = 0 
      processed.gsub!(/ed$/, "")
    end
    #puts "*** 1 #{processed}"
    processed.gsub!(/iou|eau|ai|au|ay|ea|ee|ei|oa|oi|oo|ou|ui|oy/, "@") #vowel combos
    #puts "*** 2 #{processed}"
    processed.gsub!(/qu|ng|ch|rt|[#{consonants}h]/, "=") #consonant combos
    #puts "*** 3 #{processed}"
    processed.gsub!(/[#{vowels}@][#{consonants}=]e$/, "@|") # remove silent e
    #puts "*** 4 #{processed}"
    processed.gsub!(/[#{vowels}]/, "@") #all remaining vowels will be counted
    #puts "*** 5 #{processed}"
    return processed.count("@") + suffix_bonus
  end  
end

def get_word_count
  File.open("test-book.txt") do |t|
    t.read.downcase.gsub(/[,.\/!@#$%^&*()_1234567890\[\]|'":;<>?`~+=]/, "").split(" ").length
  end
end

def avg_sentence_length
  File.open("test-book.txt") do |t|
    # split sentences into an array of words
    sentences = []
    t.read.gsub(/[\/!@#$%^&*()1234567890\[\]|'":;<>?`~+=-]/, "").split(".").each do |sentence|
      sentences << sentence.split(" ")
    end
    sentences.inject(0.0) { |sentence_length_sum, sentence_array| sentence_length_sum + sentence_array.length} / sentences.length 
  end
end

def avg_word_length
  File.open("test-book.txt") do |t|
    text = t.read.gsub(/[,.\/!@#$%^&*()1234567890\[\]|'":;<>?`~+=-]/, "")
    (text.chars.length).to_f / text.split(" ").length
  end
end

def avg_syllable_length
  File.open("test-book.txt") do |t|
    words = t.read.downcase.gsub(/[,.\/!@#$%^&*()_1234567890\[\]|'":;<>?`~+=]/, "").split(" ")
    words.inject(0.0) {|syllable_sum, word| syllable_sum + word.syllable_count } / words.length
  end
end

def parse_into_csv
  File.open("test-book.txt") do |t|
    # array of words
    words = t.read.downcase.gsub(/[,.\/!@#$%^&*()_1234567890\[\]|'":;<>?`~+=]/, "").split(" ")
    
    # chunked_words == [[word,# of occurences],[word,# of occurences]...] in desc order of occurences
    chunked_words = []
    words.sort.chunk {|word| word }.each {|word, chunk| chunked_words << [word, chunk.length]}
    chunked_words.sort_by! {|chunk| chunk[1] }
    chunked_words = chunked_words.sort {|x,y| y[1] <=> x[1]}

    # put chunks into csv file
    CSV.open("test.csv", "w", write_headers: true, headers: ["name", "count"]) do |csv|
      chunked_words.each do |chunk|
        csv << chunk
      end
    end
  end
end

def get_reading_level
  puts "(((#{avg_sentence_length} * 0.39) + (#{avg_syllable_length} * 11.8)) - 15.59).floor(2)"
    puts "(((#{avg_sentence_length * 0.39}) + (#{avg_syllable_length * 11.8})) - 15.59).floor(2)"
    puts "((#{(avg_sentence_length * 0.39) + (avg_syllable_length * 11.8)}) - 15.59).floor(2)"
    puts "(#{((avg_sentence_length * 0.39) + (avg_syllable_length * 11.8)) - 15.59}).floor(2)"
    (((avg_sentence_length * 0.39) + (avg_syllable_length * 11.8)) - 15.59)
end

puts get_reading_level