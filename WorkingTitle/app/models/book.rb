class Book < ActiveRecord::Base
	has_many :votes
	has_many :comments
	belongs_to :user

	private

	def self.search(search)
	  if search
	    find(:all, conditions: ['title LIKE ?', "%#{search}%"])
	  else
	    find(:all)
	  end
	end
end
