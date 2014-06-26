class BooksController < ApplicationController

	def all
		@books = Book.search(params[:search])
	end

	def new
		@book = Book.new
	end

	def create
		@book = Book.new(book_params)
		@book.user_id = params[:user_id]
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

	private

	def book_params
		params.require(:book).permit(:title, :author)
	end
end