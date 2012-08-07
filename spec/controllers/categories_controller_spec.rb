require 'spec_helper'

describe CategoriesController do
  let(:category) { mock_model(Category, slug: 'cool-album', hidden: false) }
  let(:admin) { Fabricate(:admin) }

  describe '#index' do
    let(:categories) { mock_models(3, Category) }

    before do
      Category.stub_chain(:roots, :accessible_by).and_return(categories)
      get :index
    end

    it { should assign_to(:categories).with(categories) }
    it { should respond_with(:success) }
    it { should render_template(:index) }
  end

  describe '#show' do
    let(:children) { mock_models(3, Album) }

    context 'when category is not hidden' do
      before do
        Category.should_receive(:find_by_slug!).and_return(category)
        category.stub_chain(:children, :accessible_by).and_return(children)
        get :show, id: category.slug
      end

      it { should assign_to(:category).with(category) }
      it { should assign_to(:children).with(children) }
      it { should respond_with(:success) }
      it { should render_template(:show) }
    end

    context 'when category is hidden' do
      let(:hidden_category) { mock_model(Category, slug: 'hidden-cool-album', hidden: true)  }

      before do
        Category.should_receive(:find_by_slug!).and_return(hidden_category)
        hidden_category.stub_chain(:children, :accessible_by).and_return(children)
      end

      context 'as an admin' do
        before do
          sign_in(admin)
          get :show, id: hidden_category.slug
        end

        it { should respond_with(:success) }
      end

      context 'as a non-admin' do
        before { get :show, id: hidden_category.slug }

        it_has_behavior('access denied')
      end
    end
  end

  describe '#new' do
    let(:new_category) { mock_model(Category) }

    before { Category.should_receive(:new).and_return(new_category) }

    context 'as an admin' do
      before do
        sign_in(admin)
        get :new
      end

      it { should assign_to(:category).with(new_category) }
      it { should respond_with(:success) }
      it { should render_template(:new) }
    end

    context 'as a non-admin' do
      before { get :new }

      it_has_behavior('access denied')
    end
  end

  describe '#edit' do
    before { Category.should_receive(:find_by_slug!).and_return(category) }

    context 'as an admin' do
      before do
        sign_in(admin)
        get :edit, id: category.slug
      end

      it { should assign_to(:category).with(category) }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end

    context 'as a non-admin' do
      before { get :edit, id: category.slug }

      it_has_behavior('access denied')
    end
  end

  describe 'POST #create' do
    let(:category_hash) { Fabricate.attributes_for(:category) }

    context 'as an admin' do
      before do
        sign_in(admin)
        post :create, category: category_hash
      end

      it 'should create a new category' do
        Category.should_receive(:new).with(category_hash).and_return(category)
        category.should_receive(:save)
        post :create, category: category_hash
      end

      it { should redirect_to(category_url(assigns[:category])) }
      it { should set_the_flash.to('Category was successfully created.') }
    end

    context 'as a non-admin' do
      before { post :create, category: category_hash }

      it_has_behavior('access denied')
    end
  end

  describe 'PUT #update' do
    let(:updated_category_hash) { Fabricate.attributes_for(:category) }

    before { Category.should_receive(:find_by_slug!).any_number_of_times.and_return(category) }

    def do_put
      put :update, id: category.slug, category: updated_category_hash
    end

    context 'as an admin' do
      before do
        sign_in(admin)
        category.stub(:update_attributes).with(updated_category_hash)
        do_put
      end

      it 'should update specied category' do
        category.should_receive(:update_attributes).with(updated_category_hash)
        do_put
      end

      it { should redirect_to(category_url(category)) }
      it { should set_the_flash.to('Category was successfully updated.') }
    end

    context 'as a non-admin' do
      before { do_put }

      it_has_behavior('access denied')
    end
  end

  describe 'DELETE #destroy' do
    before { Category.should_receive(:find_by_slug!).any_number_of_times.and_return(category) }

    def do_delete
      delete :destroy, id: category.slug
    end

    context 'as an admin' do
      before do
        sign_in(admin)
        category.stub(:destroy)
        do_delete
      end

      it 'should destroy the specified category' do
        category.should_receive(:destroy)
        do_delete
      end

      it { should redirect_to(root_url) }
      it { should set_the_flash.to('Category was successfully destroyed.') }
    end

    context 'as a non-admin' do
      before { do_delete }

      it_has_behavior('access denied')
    end
  end
end