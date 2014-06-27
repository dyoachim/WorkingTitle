class CommentsController < ApplicationController

	def create
		@comment = Comment.new(comment_params)
<<<<<<< HEAD
		@comment.commenter_id = params[:current_user_id]
=======
		@comment.commenter_id = session[:user_id]
>>>>>>> 1bc32fca6411e60976bd5c15f8510d0a5b98056a
		@comment.book_id = params[:book_id]
		if @comment.save
			redirect_to user_book_path(params[:user_id], params[:book_id])
		else
			flash[:error] = 'Please enter a valid comment, stupid.'
			flash[:color] = 'invalid'
			render user_book_path(params[:user_id], params[:id])
		end
	end

	private 

	def comment_params
		params.permit(:comment_text)
	end
end