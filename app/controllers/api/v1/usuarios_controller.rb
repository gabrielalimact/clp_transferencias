module Api 
  module V1
    class UsuariosController < ApplicationController
      def index
        usuarios = Usuario.order('created_at DESC');
        render json: {status: 'SUCCESS', message: 'Usuarios carregados', data:usuarios}, status: :ok
        # ...
      end

      def show
        usuario = Usuario.find(params[:id])
        render json: {status: 'SUCCESS', message: 'Usuario carregado', data:usuario}, status: :ok
        # ...
      end

      def historico
        id_usuario = params[:id_usuario]
        usuario = Usuario.find_by(id_usuario: id_usuario)

        if usuario.nil?
          render json: { error: 'Usuário não encontrado' }, status: :not_found
        else
          historico = HistoricoTransferencias.where(id_usuario: id_usuario)
          if not historico.nil?
            render json: historico, status: :ok
          else
            render json: { error: 'Histórico não encontrado' }, status: :not_found
          end
        end
      end
    end
  end
end