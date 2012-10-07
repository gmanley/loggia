module ControllerMacros

  shared_examples 'access denied' do
    it { should_not respond_with(:success) }
    it { should redirect_to(root_url) }
    it { should set_the_flash.to('You are not authorized to access this page.') }
  end
end
