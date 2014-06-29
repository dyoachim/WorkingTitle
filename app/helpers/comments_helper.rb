module CommentsHelper
	def nest(v, indent, comments)
		indent += 50
		if comments.empty?
			return v
		end
		comments.each do |comment|
			children = Comment.where("parent_id = ?", comment.id)
			v += render partial: "comment", locals: {comment: comment, indent: indent} 
			v = nest(v, indent, children)
		end
		v
	end
end