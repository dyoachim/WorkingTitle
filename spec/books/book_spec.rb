require 'rails_helper'

describe Book do

	let(:book){Book.create(title: "test-book")}
	
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
			expect(book.get_raw_file_path).to eq('/Users/apprentice/Desktop/WorkingTitle/public/test-book.txt')
		end
	end

	describe '#get_path_file_path' do
		it 'returns parsed file path' do
			expect(book.get_parsed_file_path).to eq('/Users/apprentice/Desktop/WorkingTitle/public/p-test-book.txt')
		end
	end

	describe '#get_reading_level' do
		it 'returns the reading level' do
			expect(book.get_reading_level).to eq(2.36)
		end
	end

	describe '#parse_into_csv' do
		it 'parses raw text into a csv == |name,count|' do

		end

		it 'should have headers' do 

		end
	end
end
