class BookssController < ApplicationController

	def index
		@books = Book.search(params[:search])
	end

	def new
		@book = Book.new
	end

	def create
		@book = Book.new(params[:book])
		if @book.save
			redirect_to book_path()
		else
			render new_book_path
		end
	end

	def show
		@book = Book.find(params[:id])
	end

	def destroy
		@book = Book.find(params[:id])
		@book.destroy
	end
end