Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :usuarios_pix, only: [:index, :show] do
        post 'transferir', to: 'transferencias#create'
        get 'historico', to: 'transferencias#historico' # Add this line
        post 'transferencia_interna', to: 'transferencia_interna#create' # Rota para a transferência interna
        get 'historico_interno', to: 'transferencia_interna#historico' # Add this line
        
      end
    end
  end
end