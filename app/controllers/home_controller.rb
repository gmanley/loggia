class HomeController < ApplicationController
  def index
    @root_categories = Category.roots.accessible_by(current_ability)
  end
end
