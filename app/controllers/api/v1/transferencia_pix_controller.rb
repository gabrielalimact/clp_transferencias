module Api
  module V1
    class TransferenciaPixController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_error

      def create
        validate_parameters
        ensure_positive_transfer_value

        ActiveRecord::Base.transaction do
          transfer_amount
          create_transfer_history(usuario_origem.id_usuario, chave_pix_origem, chave_pix_destino, -valor_transferencia)
          create_transfer_history(usuario_destino.id_usuario, chave_pix_origem, chave_pix_destino, valor_transferencia)

          render_success_response
        end

      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def historico
        id_usuario = params[:id_usuario]
        usuario = Usuario.find_by(id_usuario: id_usuario)

        if usuario.nil?
          render json: { error: 'Usuário não encontrado' }, status: :not_found
        else
          historico = HistoricoTransferencias.where(id_usuario: id_usuario, tipo_transferencia: 'pix')
          if not historico.nil?
            render json: historico, status: :ok
          else
            render json: { error: 'Histórico não encontrado' }, status: :not_found
          end
        end
      end

      private

      def validate_parameters
        raise ArgumentError, 'Parâmetros ausentes' unless params[:chave_pix_origem] && params[:chave_pix_destino] && params[:valor]
      end

      def ensure_positive_transfer_value
        raise ArgumentError, 'O valor da transferência deve ser maior que zero' unless valor_transferencia > 0
      end

      def transfer_amount
        usuario_origem.update!(saldo: usuario_origem.saldo - valor_transferencia)
        usuario_destino.update!(saldo: usuario_destino.saldo + valor_transferencia)
      end

      def create_transfer_history(id_usuario, origem, destino, valor)
        HistoricoTransferencias.create!(
          id_usuario: id_usuario,
          origem_usuario: origem,
          destino_usuario: destino,
          tipo_transferencia: 'pix',
          valor_transferencia: valor
        )
      end

      def render_success_response
        render json: {
          status: 'success',
          message: 'PIX realizada com sucesso',
          transferencia: {
            valor: valor_transferencia,
            chave_pix_origem: chave_pix_origem,
            chave_pix_destino: chave_pix_destino,
            data: Time.now
          }
        }, status: :ok
      end

      def not_found_error
        render json: { error: 'Usuário não encontrado' }, status: :not_found
      end

      def unprocessable_entity_error(exception)
        render json: { error: exception.message }, status: :unprocessable_entity
      end

      def chave_pix_origem
        @chave_pix_origem ||= params[:chave_pix_origem]
      end

      def chave_pix_destino
        @chave_pix_destino ||= params[:chave_pix_destino]
      end

      def valor_transferencia
        @valor_transferencia ||= params[:valor].to_f
      end

      def usuario_origem
        @usuario_origem ||= Usuario.find_by!(chave_pix: chave_pix_origem)
      end

      def usuario_destino
        @usuario_destino ||= Usuario.find_by!(chave_pix: chave_pix_destino)
      end
    end
  end
end
