require 'spec_helper'

describe AlbumsController do
  let(:album) { mock_model(Album, slug: 'cool-album', hidden: false) }
  let(:admin) { Fabricate(:admin) }

  describe '#index' do
    let(:albums) { mock_models(3, Album) }

    before do
      Album.stub_chain(:roots, :order, :accessible_by).and_return(albums)
      get :index
    end

    it { should assign_to(:albums).with(albums) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe '#show' do
    let(:children) { mock_models(3, Album) }
    let(:images) { mock_models(3, Image) }

    context 'when album is not hidden' do
      before do
        Album.should_receive(:find_by_slug!).and_return(album)
        album.stub_chain(:children, :accessible_by).and_return(children)
        album.stub(:images).and_return(images)
        album.stub(:comments).and_return(Comment)
        get :show, id: album.slug
      end

      it { should assign_to(:album).with(album) }
      it { should assign_to(:children).with(children) }
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

  describe '#new' do
    let(:new_album) { mock_model(Album) }

    before { Album.should_receive(:new).and_return(new_album) }

    context 'as an admin' do
      before do
        sign_in(admin)
        get :new
      end

      it { should assign_to(:album).with(new_album) }
      it { should respond_with(:success) }
      it { should render_template(:new) }
    end

    context 'as a non-admin' do
      before { get :new }

      it_has_behavior('access denied')
    end
  end

  describe '#edit' do
    before { Album.should_receive(:find_by_slug!).and_return(album) }

    context 'as an admin' do
      before do
        sign_in(admin)
        get :edit, id: album.slug
      end

      it { should assign_to(:album).with(album) }
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

    before { Album.should_receive(:find_by_slug!).any_number_of_times.and_return(album) }

    def do_put
      put :update, id: album.slug, album: updated_album_hash
    end

    context 'as an admin' do
      before do
        sign_in(admin)
        album.stub(:update_attributes).with(updated_album_hash)
        do_put
      end

      it 'should update specied album' do
        album.should_receive(:update_attributes).with(updated_album_hash)
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
    before { Album.should_receive(:find_by_slug!).any_number_of_times.and_return(album) }

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
