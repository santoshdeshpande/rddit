require 'rails_helper'

RSpec.describe Comment, :type => :model do
  
	describe 'Factory is present' do
		it 'has a valid factory' do

			expect(FactoryGirl.create(:comment)).to be_valid
		end
	end

	describe 'Validations' do

		it 'is not valid without a proper body' do
			comment = FactoryGirl.build(:comment, body: nil)
			expect(comment.valid?).to eq(false)
		end

		it 'is not valid without a user' do
			comment = FactoryGirl.build(:comment, user: nil)
			expect(comment.valid?).to eq(false)
		end
		it 'is not valid without a link' do
			comment = FactoryGirl.build(:comment, link: nil)
			expect(comment.valid?).to eq(false)
		end
	end

end
