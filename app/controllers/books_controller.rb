class BooksController < ApplicationController

	def all
		if search_params
			Rails.logger.debug(search_params)
			@books = Book.search(search_params).order("title")
			Rails.logger.debug('****************')
			Rails.logger.debug(@books[0].title)
			Rails.logger.debug('****************')
		else
			@books = Book.all.order("title")
		end
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

	def search_params
		params.permit(:search)
	end
end