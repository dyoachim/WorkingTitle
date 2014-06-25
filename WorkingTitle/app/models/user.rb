class User < ActiveRecord::Base
	has_many :books
	has_many :comments, foreign_key: :commenter_id
	has_many :votes, foreign_key: :voter_id

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: {with: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\Z/i}
	#validates :password_digest, presence: true

  has_secure_password
end
