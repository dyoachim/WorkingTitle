class Comment < ActiveRecord::Base
	belongs_to :book
	belongs_to :commenter, class_name: 'User'
end
