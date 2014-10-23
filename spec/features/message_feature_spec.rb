require 'rails_helper'
require_relative 'helpers/user_helpers'

include SessionHelpers

describe 'sending messages' do

  context 'a signed in user', js: true do

  before(:each) do
    @bob = User.create(email: 'bob@b.com', password: '123456789')
    @john = User.create(email: 'john@b.com', password: '123456789')
  end

  	it 'can send a message' do
      sign_in('john@b.com')
      visit "/message/#{@bob.id}"
      fill_in('message', :with => 'Hello')
      find_button('Send').click
      expect(current_path).to eq "/message/#{@bob.id}"
      expect(page).to have_content('Hello')
  	end

  	it 'can receive a message' do
      sign_in('bob@b.com')
      visit "/message/#{@john.id}"
      fill_in('message', :with => 'Hello John')
      find_button('Send').click
      click_link 'Sign out'
      sign_in('john@b.com')
      visit "/message/#{@bob.id}"
      expect(page).to have_content('Hello John')
  	end

    before do
      @phil = User.create(email: 'phil@b.com', password: '1234567890', password_confirmation: '1234567890')
    end
  	it 'can view last message from each message thread' do
      sign_in('john@b.com')
      visit "/message/#{@bob.id}"
      fill_in('message', :with => 'Hello Bob')
      find_button('Send').click
      visit "/message/#{@phil.id}"
      fill_in('message', :with => 'Hello Phil')
      find_button('Send').click
      visit '/messages'
      expect(page).to have_content('Hello Bob')
      expect(page).to have_content('Hello Phil')
  	end

  end

end
