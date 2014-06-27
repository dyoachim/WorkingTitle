class VotesController < ApplicationController

	def upvote
		@vote = Vote.create(voter_id: session[:current_user_id], book_id: params[:book_id], up_or_down: 1)
		
		respond_to do |format|
      format.html
      format.json { render json: @vote.to_json }
    end
	end

	def downvote
		@vote = Vote.create(voter_id: session[:current_user_id], book_id: params[:book_id], up_or_down: -1)
		
		respond_to do |format|
      format.html
      format.json { render json: @vote.to_json }
    end
	end
end