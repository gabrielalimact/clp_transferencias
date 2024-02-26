module Api 
  module V1
    class UsuariosPixController < ApplicationController
      def index
        usuarios = UsuarioPix.order('created_at DESC');
        render json: {status: 'SUCCESS', message: 'Usuarios carregados', data:usuarios}, status: :ok
        # ...
      end

      def show
        usuario = UsuarioPix.find(params[:id])
        render json: {status: 'SUCCESS', message: 'Usuario carregado', data:usuario}, status: :ok
        # ...
      end
    end
  end
end