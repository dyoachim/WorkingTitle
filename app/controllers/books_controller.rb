class BooksController < ApplicationController

	def all
		@books = Book.search(params[:search])
	end

	def new
		@book = Book.new
	end

	def create
		@book = Book.new(params[:book])
		@book.user_id = params[:user_id]
		# @book.parsed_file_path = 
		# @book.word_count = 
		# @book.avg_word_length =
		# @book.avg_syllable_length =
		# @book.avg_sentence_length =
		# @book.reading_level =
		if @book.save
			redirect_to user_book_path(params[:user_id], @book)
		else
			render new_user_book_path(params[:user_id])
		end
	end

	def show
		@book = Book.find(params[:id])
		@comments = @book.comments
	end

	def destroy
		@book = Book.find(params[:id])
		@book.destroy
	end
end