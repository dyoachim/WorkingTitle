class CommentsController < ApplicationController

	def create
		@comment = Comment.new(params[:comment])
		@comment.commenter_id = current_user.id
		@comment.book_id = params[:book_id]
		if @comment.save
			redirect_to user_book_path(params[:user_id], params[:id])
		else
			flash[:error] = 'Please enter a valid comment, stupid.'
			flash[:color] = 'invalid'
			render user_book_path(params[:user_id], params[:id])
		end
	end
end