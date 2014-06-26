class Vote < ActiveRecord::Base
	belongs_to :book
	belongs_to :voter, class_name: 'User'
end
