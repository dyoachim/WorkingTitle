class CommentsController < ApplicationController

	def create
		@comment = Comment.new(comment_params)
		@comment.commenter_id = session[:current_user_id]
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
		params.permit(:comment_text, :parent_id)
	end
end