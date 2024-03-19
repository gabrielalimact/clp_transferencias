module Api
  module V1
    class TransferenciaInternaController < ApplicationController
      def create
        user_id = params[:usuarios_pix_id]
        destino_conta = params[:destino_conta]
        destino_agencia = params[:destino_agencia]
        valor_transferencia = params[:valor_transferencia]

        usuario_atual = UsuarioPix.find_by(id_usuario: user_id)
        destinatario = UsuarioPix.find_by(conta: destino_conta, agencia: destino_agencia)

        if usuario_atual.nil?
          render json: { error: "Usuário não encontrado" }, status: :not_found
          return
        elsif destinatario.nil?
          render json: { error: "Destinatário não encontrado" }, status: :not_found
          return
        end

        # Verificar se o usuário tem saldo suficiente
        if usuario_atual.saldo < valor_transferencia.to_f
          render json: { error: "Saldo insuficiente" }, status: :unprocessable_entity
          return
        end

        ActiveRecord::Base.transaction do
          create_transfer_history(usuario_atual.id_usuario, usuario_atual.conta, destinatario.conta, -valor_transferencia.to_f)
          create_transfer_history(destinatario.id_usuario, destinatario.conta, destinatario.conta, valor_transferencia.to_f)
        end

        render_success_response(valor_transferencia.to_f, usuario_atual, destinatario)
      end

      
      def historico
        user_id = params[:usuarios_pix_id]
        usuario = UsuarioPix.find_by(id_usuario: user_id)
      
        if usuario.nil?
          render json: { error: 'Usuário não encontrado' }, status: :not_found
        else
          historico = HistoricoTransferencias.where(id_usuario: user_id)
          if historico.any?
            render json: historico, status: :ok
          else
            render json: { error: 'Histórico não encontrado' }, status: :not_found
          end
        end
      end
      

      private

      def create_transfer_history(id_usuario, origem, destino, valor)
        HistoricoTransferencias.create!(
          id_usuario: id_usuario,
          origem_usuario: origem,
          destino_usuario: destino,
          tipo_transferencia: 'interna',
          valor_transferencia: valor
        )
      end

      def render_success_response(valor_transferencia, usuario_atual, destinatario)
        render json: {
          status: 'success',
          message: 'Transferência realizada com sucesso',
          transferencia: {
            valor: valor_transferencia,
            origem: usuario_atual,
            destino: destinatario,
            data: Time.now
          }
        }, status: :ok
      end
    end
  end
end
