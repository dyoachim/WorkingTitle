module CommentsHelper
	def nest(v, comments)
		if comments.empty?
			return
		end
		
		comments.each do |comment|
			puts comment.comment_text
			v += render partial: "comment", locals: {comment: comment}

			children = Comment.where("parent_id = ?", comment.id)
			nest(v, children)
		end
		puts v
		v
	end
end