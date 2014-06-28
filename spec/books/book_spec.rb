require 'rails_helper'

describe Book do

<<<<<<< HEAD
	let!(:book){Book.create(title: "test-book", author: "")}
	let!(:book1){Book.create(title: "sherlock", author: "sir arthur conan doyle")}
	let!(:book2){Book.create(title: "kafka", author: "author!")}
	
=======
	let(:book){Book.create(title: "test-book")}

>>>>>>> 53b60fcade45228f0569cb6e1c26eac2a45fa56a
	describe '#get_word_count' do
		it 'returns the word count' do
			expect(book.get_word_count).to eq(11)
		end
	end

	describe '#get_avg_sentence_length' do
		it 'returns the sentence length average' do
			expect(book.get_avg_sentence_length).to eq(3.6666666666666665)
		end
	end

	describe '#get_avg_word_length' do
		it 'returns the word length average' do
      expect(book.get_avg_word_length).to eq(3.3636363636363638)
		end
	end

	describe '#get_avg_syllable_length' do
		it 'returns the syllable length average' do
			expect(book.get_avg_syllable_length).to eq(1.4)
		end
	end

	describe '#get_raw_file_path' do
		it 'returns raw file path' do
			expect(book.get_raw_file_path).to eq("#{Rails.root}/public/test-book.txt")
		end
	end

	describe '#get_path_file_path' do
		it 'returns parsed file path' do
			expect(book.get_parsed_file_path).to eq("#{Rails.root}/public/p-test-book.txt")
		end
	end

	describe '#get_reading_level' do
		it 'returns the reading level' do
			expect(book.get_reading_level).to eq(2.36)
		end
	end

	describe 'leading book methods' do
		let!(:sherlock_book){Book.create(title: "sherlock")}
		let!(:kafka_book){Book.create(title: "kafka")}
		let!(:ulysses_book){Book.create(title: "ulysses")}

		describe '#get_highest_level_book' do
			it "returns the book with the highest reading level" do
				expect(Book.get_highest_level_book).to eq(kafka_book)
			end
		end

		describe '#get_most_words_book' do
			it "returns the book with the highest word count" do
				expect(Book.get_most_words_book).to eq(ulysses_book)
			end
		end

		describe '#get_highest_word_length_book' do
			it "returns the book with the longest average word length" do
				expect(Book.get_highest_word_length_book).to eq(ulysses_book)
			end
		end

		describe '#get_most_syllable_book' do
			it "returns the book with the longest average syllables per word" do
				expect(Book.get_most_syllable_book).to eq(ulysses_book)
			end
		end

		describe '#get_longest_sentences_book' do
			it "returns the book with the longest average sentences" do
				expect(Book.get_longest_sentences_book).to eq(kafka_book)
			end
		end
	end

	describe '#parse_into_csv' do
		it 'parses raw text into a csv == |name,count|' do
			book.parse_into_csv
			text = ""
			File.open("#{Rails.root}/public/p-test-book.txt") do |t|
				text = t.read
			end

			expect(text[11..14]).to eq("is,2")
		end

		it 'should have headers' do
			book.parse_into_csv
			text = ""
			File.open("#{Rails.root}/public/p-test-book.txt") do |t|
				text = t.read
			end

			expect(text[0..9]).to eq("name,count")
		end
	end

	describe '#search' do

		it 'should return all books if there are no search params' do
			found_books = Book.search('nothing')
			expect(found_books.first.title).to eq('test-book')
		end
	end
end
