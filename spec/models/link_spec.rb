require 'rails_helper'

RSpec.describe Link, :type => :model do

  describe 'Validations' do
    it 'has a valid factory' do
      expect(FactoryGirl.create(:link)).to be_valid
    end

    it 'is not valid without a title' do
      link = FactoryGirl.build(:link, :title => nil)
      expect(link.valid?).to eq(false)
    end

    it 'is not valid without a url' do
      link = FactoryGirl.build(:link, :url => nil)
      expect(link.valid?).to eq(false)
    end

  end

  describe 'Vote links' do
    it 'has 0 vote count when created' do
      expect(FactoryGirl.create(:link).vote_count).to eq(0)
    end

    it 'returns the number of votes registered' do
      user = FactoryGirl.create(:user)
      link = FactoryGirl.create(:link)
      link.upvote_by user
      link.save
      link.reload
      expect(link.vote_count).to eq(1)
    end

    it 'returns the number of up votes registered' do
      user = FactoryGirl.create(:user)
      link = FactoryGirl.create(:link)
      link.upvote_by user
      link.save
      link.reload
      expect(link.upvote_count).to eq(1)
    end
    
    it 'returns the number of up votes registered' do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      link = FactoryGirl.create(:link)
      link.downvote_by user
      link.upvote_by user2
      link.save
      link.reload
      expect(link.downvote_count).to eq(1)
      expect(link.upvote_count).to eq(1)
    end

  end
end
