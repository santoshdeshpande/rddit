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

  describe 'new' do
    before do
      user = FactoryGirl.create(:user)
      sign_in user
    end
    context 'when new is called' do
      it 'creates a link' do
        expect(response.status).to eq(200)
        post :new
        expect(assigns(:current_user).links.first).to be_a_new(Link)
      end
    end
  end



  describe 'delete' do
    before do
      user = FactoryGirl.create(:user)
      sign_in user
      @link1 = FactoryGirl.create(:link, user: user)
      @link2 = FactoryGirl.create(:link)
    end

    it 'should not allow link created by others to delete a link' do
      expect(response.status).to_not eq(302)
      expect{ 
        delete :destroy, :id => @link2.id
      }.to_not change(Link, :count)

    end

    it 'should allow to delete a user create link' do
      expect(response.status).to_not eq(302)
      expect{ 
        delete :destroy, :id => @link1.id
      }.to change(Link, :count)
      expect(response).to redirect_to(:links)
    end

  end

  describe 'update' do
    before do
      user = FactoryGirl.create(:user)
      sign_in user
      @link1 = FactoryGirl.create(:link, user: user)
      @link2 = FactoryGirl.create(:link, title: 'Title')
    end

    it 'should not allow link created by others to be updates' do
      expect(response.status).to_not eq(302)
      put :update, {:id => @link2.id, :link => {:title => 'Changed title'}}
      expect(@link2.title).to eq('Title')
    end

    it 'should allow to update a user created link' do      
      expect{ 
        put :update, {:id => @link1.id, :link => {:title => 'Changed title'}}
      }.to_not change(Link, :count)    
      expect(response.status).to eq(302)
      expect(response).to redirect_to(@link1)
      @link1.reload
      expect(@link1.title).to eq('Changed title')
    end

    it 'should edit the link if the link does not have valid title' do
      expect{ 
        put :update, {:id => @link1.id, :link => {:title => ''}}
      }.to_not change(Link, :count)    
      expect(response.status).to eq(200)
      expect(response).to render_template :edit
    end
  end

  describe 'show' do
    it 'shows a link identified by the id' do
      link1 = FactoryGirl.create(:link)
      link2 = FactoryGirl.create(:link)
      expect(response.status).to eq(200)
      get :show, id: link1.id
      expect(response).to render_template :show
    end
  end

  describe 'create' do
    before do
      user = FactoryGirl.create(:user)
      sign_in user
    end

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

  describe 'Voting' do
    before do
      request.env['HTTP_REFERER'] = 'somewhere'
      @link_user = FactoryGirl.create(:user)
      @vote_user = FactoryGirl.create(:user)
      @link = FactoryGirl.create(:link, user: @link_user)
      sign_in @vote_user
    end

    it 'upvotes a link by an user' do
      put :upvote, :id => @link.id
      expect(response.status).to eq(302)
      expect(response).to redirect_to('somewhere')
      @link.reload
      expect(@link.vote_count).to eq(1)
      expect(@link.upvote_count).to eq(1)
      expect(@link.downvote_count).to eq(0)
    end

    it 'downvotes a link by an user' do
      put :downvote, :id => @link.id
      expect(response.status).to eq(302)
      expect(response).to redirect_to('somewhere')
      @link.reload
      expect(@link.vote_count).to eq(1)
      expect(@link.upvote_count).to eq(0)
      expect(@link.downvote_count).to eq(1)
    end

    describe 'My Submissions' do
      before do
        @user1 = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user)
        @link1 = FactoryGirl.create(:link, user: @user1)
        @link2 = FactoryGirl.create(:link, user: @user1)
        @link3 = FactoryGirl.create(:link, user: @user2)
        sign_in @user1
      end

      it 'should only fetch the logged in users submissions' do 
        get :my_submissions
        expect(assigns(:links)).to match_array([@link1,@link2])
        expect(response).to render_template :index
      end
    end

  end
end
