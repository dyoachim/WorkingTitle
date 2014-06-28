require 'rails_helper'

feature 'Upload a new book' do

	let!(:user) { User.create(first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime') }
	let!(:book) { Book.create!(title: 'kafka', author: 'meta') }

  it 'should create a new book object' do
    visit root_path
    fill_in 'email', with: user.email
    fill_in 'password', with: "caketime"
    click_on 'Login'
    visit new_user_book_path(user)
    fill_in 'book[title]', with: 'kafka'
    fill_in 'book[author]', with: 'meta'
    page.attach_file('book[file]', "#{Rails.root}/public/kafka.txt")
    click_on 'Create Book'
    expect(Book.first.title).to eq('kafka')
  end

  it 'should redirect to the new book show page' do
    visit root_path
    fill_in 'email', with: user.email
    fill_in 'password', with: "caketime"
    click_on 'Login'
    visit new_user_book_path(user)
    fill_in 'book[title]', with: 'kafka'
    fill_in 'book[author]', with: 'meta'
    page.attach_file('book[file]', "#{Rails.root}/public/kafka.txt")
    click_on 'Create Book'
    expect(current_path).to eq(user_book_path(user.id, Book.last.id))
  end
end

feature 'Comment on book' do

  let!(:user) { User.create(first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime') }
  let!(:book) { Book.create!(title: 'kafka', author: 'meta') }

  it 'should create a new comment' do
		visit root_path
		fill_in 'email', with: user.email
    fill_in 'password', with: "caketime"
    click_on 'Login'
		visit user_book_path(user, book)
		fill_in 'comment_text', with: 'Comment time!'
		click_on 'Add Comment'
		expect(Comment.last.comment_text).to eq('Comment time!')
	end

	it 'should appear on reload' do
		visit root_path
		fill_in 'email', with: user.email
    fill_in 'password', with: "caketime"
    click_on 'Login'
		visit user_book_path(user.id, book.id)
		fill_in 'comment_text', with: 'Comment time!'
		click_on 'Add Comment'
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
# 		@user = User.create(first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime')
# 		visit root_path
# 		fill_in 'email', with: @user.email
#     fill_in 'password', with: "caketime"
#     click_on 'Login'
# 		visit_user_book_path(@user.id, @book.id)
# 		click_on 'UP'
# 		expect(Vote.last.up_or_down).to eq(1)
# 	end

# 	it 'upvote should add one to total vote count' do
# 		@user = User.create(first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime')
# 		visit root_path
# 		fill_in 'email', with: @user.email
#     fill_in 'password', with: "caketime"
#     click_on 'Login'
# 		visit_user_book_path(@user.id, @book.id)
# 		click_on 'UP'
# 		expect(page).to have_content(1)
# 	end

# 	it 'downvote should subtract one from total vote count' do
# 		@user = User.create(first_name: 'Natalie', last_name: 'Frecka', email: 'nfrecka@gmail.com', password: 'caketime')
# 		visit root_path
# 		fill_in 'email', with: @user.email
#     fill_in 'password', with: "caketime"
#     click_on 'Login'
# 		visit_user_book_path(@user.id, @book.id)
# 		click_on 'UP'
# 		click_on 'DOWN'
# 		expect(page).to have_content(0)
# 	end
#end
