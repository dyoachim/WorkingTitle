class User < ActiveRecord::Base
	has_many :books
	has_many :comments, foreign_key: :commenter_id
	has_many :votes, foreign_key: :voter_id

	has_secure_password
end
