ActionController::Routing::Routes.draw do |map|

  # Main RESTful routes for Assets
  map.namespace :admin, :member => { :remove => :get }, :collection => { :refresh => :post } do |admin|
    admin.resources :assets
  end
end

