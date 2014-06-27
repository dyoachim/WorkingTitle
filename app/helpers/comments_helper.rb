module CommentsHelper
	def nest(comments)
		comments.each do |comment|
			children = Comment.where("parent_id = ?", comment.id) 
			real_children = children.reject{|child| child.parent_id == nil}
			
			Rails.logger.debug(comment.comment_text)
			if !real_children.empty?  
				nest(real_children)
			end
		end
	end
end
# parent 1
#   |_child 1
#     |_child_child 1
#   |_child 2
# parent 2