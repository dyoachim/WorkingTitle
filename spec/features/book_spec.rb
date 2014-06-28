require 'rails_helper'

feature 'Upload a new book' do
	it 'should create a new book object' do
		user = User.create(first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime')
		visit root_path
		fill_in 'email', with: user.email
    fill_in 'password', with: "caketime"
    click_on 'Login'
    visit new_user_book_path(user)
    fill_in 'book[title]', with: 'kafka'
    fill_in 'book[author]', with: 'meta'
    page.attach_file('book[file]', '/Users/Natalie/Desktop/WorkingTitle/public/kafka.txt')
    click_on 'Create Book'
    expect(Book.first.title).to eq('kafka')
	end

	it 'should redirect to the new book show page' do
		user = User.create(first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime')
		visit root_path
		fill_in 'email', with: user.email
    fill_in 'password', with: "caketime"
    click_on 'Login'
    visit new_user_book_path(user)
    fill_in 'book[title]', with: 'kafka'
    fill_in 'book[author]', with: 'meta'
    page.attach_file('book[file]', '/Users/Natalie/Desktop/WorkingTitle/public/kafka.txt')
    click_on 'Create Book'
		expect(current_path).to eq(user_book_path(@user, Book.last))
	end
end

feature 'Comment on book' do
	it 'should create a new comment' do
		user = User.create(id: 1, first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime')
		Book.create!(id: 1, title: 'kafka', author: 'meta')
		visit user_book_path(1, 1)
		fill_in 'comment_text', with: 'Comment time!'
		click_on 'Add Comment'
		expect(Comment.last.comment_text).to eq('Comment time!')
	end

	it 'should appear on reload' do
		visit user_book_path(1, 1)
		expect(page).to have_content "Comment time!"
	end
end

# feature 'Reply to user comment' do
# 	it 'should create a comment with a parent id equal to original comment id' do
# 		
# 	end
# end
 
# feature 'Voting on books' do
# 	it 'should create a new vote' do
		# user = User.create(id: 1, first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime')
		# Book.create!(id: 1, title: 'kafka', author: 'meta')
# 	end
# 	
# 	it 'upvote should add one to total vote count' do

# 	end
# 	
# 	it 'downvote should subtract one from total vote count' do

# 	end
# end

# feature 'Search for books' do
# 	it 'display books that with similar title to search text' do

# 	end
# 	
# 	it 'display books that with similar author to search text' do

# 	end
# 	
# 	it 'display all books if search yields no results' do

# 	end
# end