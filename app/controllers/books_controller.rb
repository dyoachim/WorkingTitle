class BooksController < ApplicationController



	def all
		if search_params
			@books = Book.search(search_params).order("title")
			if @books.any?
				@books
			else
				@books = Book.all.order("title")
			end
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

	def recent
		@recent_books = Book.order(created_at: :desc)
	end

	def popular
		@popular_books = Book.joins(:votes).group("books.id").order("sum(votes.up_or_down) desc")
	end

	private

	def book_params
		params.require(:book).permit(:title, :author)
	end

	def search_params
		params.permit(:search)
	end
end
