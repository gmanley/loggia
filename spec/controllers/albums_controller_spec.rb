require 'spec_helper'

describe AlbumsController do
  shared_examples 'access denied' do
    it { should_not respond_with(:success) }
    it { should redirect_to(root_url) }
    it { should set_the_flash.to('You are not authorized to access this page.') }
  end

  let(:album) { mock_model(Album, slug: 'cool-album', hidden: false) }
  let(:admin) { Fabricate(:admin) }

  describe 'GET #index' do
    let(:albums)        { mock_models(Album, 3) }
    let(:recent_albums) { mock_models(Album, 3) }

    before do
      Album.stub_chain(:roots, :order, :accessible_by).and_return(albums)
      Album.stub_chain(:recently_updated, :limit, :accessible_by).and_return(recent_albums)
      get :index
    end

    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe 'GET #show' do
    let(:children) { mock_models(Album, 3) }
    let(:images)   { mock_models(Image, 3) }

    context 'when album is not hidden' do
      before do
        Album.should_receive(:find_by_slug!).and_return(album)
        album.stub_chain(:children, :accessible_by).and_return(children)
        album.stub(:images).and_return(images)
        album.stub(:comments).and_return(Comment)
        get :show, id: album.slug
      end

      it { should respond_with(:success) }
      it { should render_template(:show) }
    end

    context 'when album is hidden' do
      let(:hidden_album) { mock_model(Album, slug: 'hidden-cool-album', hidden: true)  }

      before do
        Album.should_receive(:find_by_slug!).and_return(hidden_album)
        hidden_album.stub_chain(:children, :accessible_by).and_return(children)
        hidden_album.stub(:images).and_return(images)
        hidden_album.stub(:comments).and_return(Comment)
      end

      context 'as an admin' do
        before do
          sign_in(admin)
          get :show, id: hidden_album.slug
        end

        it { should respond_with(:success) }
      end

      context 'as a non-admin' do
        before { get :show, id: hidden_album.slug }

        it_has_behavior('access denied')
      end
    end
  end

  describe 'GET #new' do
    let(:new_album) { mock_model(Album) }

    before { Album.should_receive(:new).and_return(new_album) }

    context 'as an admin' do
      before do
        sign_in(admin)
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template(:new) }
    end

    context 'as a non-admin' do
      before { get :new }

      it_has_behavior('access denied')
    end
  end

  describe 'GET#edit' do
    before { Album.should_receive(:find_by_slug!).and_return(album) }

    context 'as an admin' do
      before do
        sign_in(admin)
        get :edit, id: album.slug
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    context 'as a non-admin' do
      before { get :edit, id: album.slug }

      it_has_behavior('access denied')
    end
  end

  describe 'POST #create' do
    let(:album_hash) { Fabricate.attributes_for(:album) }

    context 'as an admin' do
      before do
        sign_in(admin)
        post :create, album: album_hash
      end

      it 'should create a new album' do
        Album.should_receive(:new).with(album_hash).and_return(album)
        album.should_receive(:save)
        post :create, album: album_hash
      end

      it { should redirect_to(album_url(assigns[:album])) }
      it { should set_the_flash.to('Album was successfully created.') }
    end

    context 'as a non-admin' do
      before { post :create, album: album_hash }

      it_has_behavior('access denied')
    end
  end

  describe 'PUT #update' do
    let(:updated_album_hash) { Fabricate.attributes_for(:album) }

    before { Album.stub(:find_by_slug!).and_return(album) }

    def do_put
      put :update, id: album.slug, album: updated_album_hash
    end

    context 'as an admin' do
      before do
        sign_in(admin)
        album.stub(:update).with(updated_album_hash)
        do_put
      end

      it 'should update specied album' do
        album.should_receive(:update).with(updated_album_hash)
        do_put
      end

      it { should redirect_to(album_url(album)) }
      it { should set_the_flash.to('Album was successfully updated.') }
    end

    context 'as a non-admin' do
      before { do_put }

      it_has_behavior('access denied')
    end
  end

  describe 'DELETE #destroy' do
    before { Album.stub(:find_by_slug!).and_return(album) }

    def do_delete
      delete :destroy, id: album.slug
    end

    context 'as an admin' do
      before do
        sign_in(admin)
        album.stub(:destroy)
        do_delete
      end

      it 'should destroy the specified album' do
        album.should_receive(:destroy)
        do_delete
      end

      it { should redirect_to(root_url) }
      it { should set_the_flash.to('Album was successfully destroyed.') }
    end

    context 'as a non-admin' do
      before { do_delete }

      it_has_behavior('access denied')
    end
  end
end
