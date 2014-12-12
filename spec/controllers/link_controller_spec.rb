require 'rails_helper'

RSpec.describe LinksController, :type => :controller do

  describe 'GET#index' do
    it 'populates an array of links' do
      link = FactoryGirl.create(:link)
      get :index
      expect(assigns(:links)).to eq([link])
    end
    it 'renders the index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'create' do
    context 'when valid params' do
      it 'creates a new link' do
        expect(response.status).to eq(200)
        expect {
          post :create, link: FactoryGirl.attributes_for(:link)
        }.to change(Link,:count).by(1)
      end
    end

    context 'when invalid params' do
      it 'does not create a link' do
        expect(response.status).to eq(200)
        expect {
          post :create, link: FactoryGirl.attributes_for(:invalid_link)
        }.to_not change(Link, :count)
      end
    end
  end
end
