require 'rails_helper'

describe SessionsController do
  it 'logs in the user' do
    @user = User.create!(first_name: "Dan", last_name: "Y", email: 'f@f.com', password: "password")
    visit root_path
    fill_in 'email', with: @user.email
    fill_in 'password', with: "password"
    click_on 'Login'
    expect(current_path).to eq(user_path(@user))
  end

  it 'logs out the user' do
    @user = User.create!(first_name: "Dan", last_name: "Y", email: 'f@f.com', password: "password")
    visit root_path
    fill_in 'email', with: @user.email
    fill_in 'password', with: "password"
    click_on 'Login'
    expect(current_path).to eq(user_path(@user))
    click_on 'Logout'
    expect(current_path).to eq(root_path)
  end
end
