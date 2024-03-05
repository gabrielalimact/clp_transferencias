Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :usuarios_pix, only: [:index, :show] do
        post 'transferir_pix', to: 'transferencias#create'
        get 'historico', to: 'transferencias#historico' # Add this line
      end
    end
  end
end