Rails.application.routes.draw do
  namespace 'api' do
  	namespace 'v1' do
  		resources :usuarios_pix
  	end
  end
end