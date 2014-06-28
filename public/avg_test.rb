require "csv"
require "json"

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
    stop_words = ["the", "a", "about", "above", "above", "across", "-", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount", "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as", "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]
  File.open("kafka.txt") do |t|
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
    CSV.open("kafka.csv", "w", write_headers: true, headers: ["name", "count"]) do |csv|
      chunked_words.each do |chunk|
        csv << chunk
        json_chunks  = {name: chunk[0], size: chunk[1]} 
          # puts json_chunks[:name]
        json_array << json_chunks unless stop_words.include? json_chunks[:name]      
          end
        json_array = json_array.first(30)
        File.open("flare.json","w") do |f|
        f.write('{ "children": ')
        f.write(json_array.to_json)
        f.write("}")
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
parse_into_csv
