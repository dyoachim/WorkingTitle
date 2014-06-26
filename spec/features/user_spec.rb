require 'rails_helper'

feature 'User browsing the website' do
  it "creates new user" do
    visit new_user_url
    fill_in 'user[first_name]',   with: "Dan"
    fill_in 'user[last_name]', with: "Y"
    fill_in 'user[email]', with: "dan@dan.com"
    fill_in 'user[password]', with: "password"
    click_button 'Join'
    expect(User.all.last.first_name).to eq 'Dan'
  end

  it 'edits user fields' do
    @user = User.create(first_name: "Dan", last_name: "Y", email: 'dan@dan.com', password: "password")
    visit edit_user_path(@user)
    fill_in 'user[first_name]',   with: "Daniel"
    click_button 'Update'
    expect(User.find(@user.id).first_name).to eq 'Daniel'
  end

  it 'deletes user' do
    @user = User.create(first_name: "Dan", last_name: "Y", email: 'dan@dan.com', password: "password")
    visit edit_user_path(@user)
    click_link 'Delete'
    expect(User.all.count).to eq(0)
  end
end
