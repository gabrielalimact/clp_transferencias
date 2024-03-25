Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :usuarios, only: [:index, :show] do
        get 'usuarios', to: 'usuarios#show' # Add this line
        get 'historico', to: 'usuarios#historico' # Add this line
        post 'transferencia_pix', to: 'transferencia_pix#create'
        get 'historico_pix', to: 'transferencia_pix#historico' # Add this line
        post 'transferencia_interna', to: 'transferencia_interna#create' # Rota para a transferência interna
        get 'historico_interno', to: 'transferencia_interna#historico' # Add this line
        post 'transferencia_externa', to: 'transferencia_externa#create' # Rota para a transferência interna
        get 'historico_externo', to: 'transferencia_externa#historico' # Add this line
      end
    end
  end
end