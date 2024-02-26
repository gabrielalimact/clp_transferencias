Rails.application.routes.draw do
  namespace 'api' do
  	namespace 'v1' do
  		resources :usuarios_pix, only: [:index, :show] do
        post 'transferir', to: 'transferencias#create'

      end
  	end
  end
end