require 'spec_helper'

describe CategoriesController do

  let(:admin) { Fabricate(:admin) }

  describe 'GET #index' do
    let(:categories) { FabricateMany(3, :category) }

    before { Category.stub_chain(:roots, :accessible_by).and_return(categories) }

    it 'should be successful' do
      get 'index'
      response.should be_success
    end

    it 'should assign @categories' do
      get 'index'
      assigns[:categories].should eql(categories)
    end
  end

  describe 'GET #show' do
    let(:category) { Fabricate(:category) }
    let(:children) { FabricateMany(3, :category).concat(FabricateMany(3, :album)) }


    before do
      Category.should_receive(:find_by_slug!).and_return(category)
      category.stub_chain(:children, :accessible_by).and_return(children)
    end

    it 'should be successful' do
      get :show, id: category.slug
      response.should be_success
    end

    it 'should assign @category' do
      get :show, id: category.slug
      assigns[:category].should eql(category)
    end
  end

  describe 'GET #new' do
    context 'when signed in as a admin' do

      before { sign_in(admin) }

      it 'succeeds' do
        get :new
        response.should be_success
      end
    end
  end

  describe 'GET #edit' do
    context 'when signed in as a admin' do

      before { sign_in(admin) }

      let(:category) { Fabricate(:category) }

      it 'should be successful' do
        get :edit, id: category.slug
        response.should be_success
      end
    end
  end

  describe 'POST #create' do
    context 'when signed in as a admin' do

      before { sign_in(admin) }

      context 'with valid attributes' do
        let(:category_hash) { Fabricate.attributes_for(:category) }

        it 'should create a new category with the provided attributes' do
           -> {
             post 'create', category: category_hash
           }.should change(Category, :count).by(1)
           post :create
        end

        it 'should redirect to created category with a notice' do
          post 'create', category: category_hash
          response.should redirect_to(category_url(assigns[:category]))
        end

        it 'should display a flash message' do
          post 'create', category: category_hash
          flash[:notice].should eq('Category was successfully created.')
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when signed in as a admin' do
      let(:category) { Fabricate(:category) }
      let(:updated_category_params) { Fabricate.attributes_for(:category) }

      before do
        sign_in(admin)
        Category.should_receive(:find_by_slug!).and_return(category)
      end

      it 'updates the category' do
        category.should_receive(:update_attributes).with(updated_category_params)
        put 'update', id: category.slug, category: updated_category_params
      end

      it 'redirects user to updated category and displays flash message' do
        put 'update', id: category.slug, category: updated_category_params

        response.should redirect_to(category_url(assigns[:category]))
        flash[:notice].should eq('Category was successfully updated.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when signed in as a admin' do
      let(:category) { Fabricate(:category) }

      before do
        sign_in(admin)
        Category.should_receive(:find_by_slug!).and_return(category)
      end

      it 'should be successful' do
        delete 'destroy', id: category.slug

        response.should redirect_to(root_url)
        flash[:notice].should eq('Category was successfully destroyed.')
      end
    end
  end
end