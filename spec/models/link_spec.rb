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
end
