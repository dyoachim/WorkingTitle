class BooksController < ApplicationController

	def all
		@books = Book.search(params[:search])
	end

	def index
		@books = Book.find_by_user_id(params[:user_id])
	end

	def new
		@book = Book.new
	end

	def create
		@book = Book.new(params[:book])
		@book.user_id = params[:user_id]
		if @book.save
			redirect_to user_book_path(params[:user_id], @book)
		else
			render new_user_book_path(params[:user_id])
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