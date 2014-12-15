require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do

	before do
		@user = FactoryGirl.create(:user)
		sign_in @user
	end
	describe 'create' do
		it 'should not create a comment without a valid link' do
			post :create, {:link_id => 10, :body => 'Hello World this is a test'}
			expect(flash[:notice]).to eq('Could not find link')
			expect(response).to redirect_to(:links)
		end

		it 'should create a comment for a valid link' do
			link = FactoryGirl.create(:link)
			post :create, {:link_id => link.id, :comment => {:body => 'Hello World this is a test'}}
			link.reload
			expect(response).to redirect_to(link)
			expect(link.comments.size).to eq(1)
			expect(link.comments[0].user).to eq(@user)
			expect(flash[:notice]).to eq('Comment created successfully')
		end

		it 'should not create a comment for invalid body' do
			link = FactoryGirl.create(:link)
			post :create, {:link_id => link.id, :comment => {:body => nil}}
			link.reload
			expect(response).to redirect_to(link)
			expect(link.comments.size).to eq(0)			
			expect(flash[:notice]).to eq('Comment could not be created')			
		end

	end
end
