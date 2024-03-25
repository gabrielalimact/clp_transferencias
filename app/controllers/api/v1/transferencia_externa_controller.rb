module Api
  module V1
    class TransferenciaExternaController < ApplicationController
      def create
        validate_parameters
        user_id = params[:usuario_id]
        destino_conta = params[:destino_conta]
        destino_agencia = params[:destino_agencia]
        destino_banco = params[:destino_banco]
        valor_transferencia = params[:valor_transferencia]

        usuario_atual = Usuario.find_by(id_usuario: user_id)
        destinatario = Usuario.find_by(conta: destino_conta, agencia: destino_agencia, banco: destino_banco)

        if usuario_atual.nil?
          render json: { error: "Usuário não encontrado" }, status: :not_found
          return
        elsif destinatario.nil?
          render json: { error: "Destinatário não encontrado" }, status: :not_found
          return
        end

        if valor_transferencia.to_f <= 0
          render json: { error: "O valor da transferência deve ser maior que zero" }, status: :unprocessable_entity
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
        user_id = params[:usuario_id]
        usuario = Usuario.find_by(id_usuario: user_id)
      
        if usuario.nil?
          render json: { error: 'Usuário não encontrado' }, status: :not_found
        else
          historico = HistoricoTransferencias.where(id_usuario: user_id, tipo_transferencia: 'externa')
          if not historico.nil?
            render json: historico, status: :ok
          else
            render json: { error: 'Histórico não encontrado' }, status: :not_found
          end
        end
      end
      

      private

      def validate_parameters
        raise ArgumentError, 'Parâmetros ausentes' unless params[:destino_conta] && params[:destino_agencia] && params[:valor_transferencia] && params[:destino_banco]
      end

      def create_transfer_history(id_usuario, origem, destino, valor)
        HistoricoTransferencias.create!(
          id_usuario: id_usuario,
          origem_usuario: origem,
          destino_usuario: destino,
          tipo_transferencia: 'externa',
          valor_transferencia: valor
        )
      end

      def render_success_response(valor_transferencia, usuario_atual, destinatario)
        render json: {
          status: 'success',
          message: 'Transferência Externa realizada com sucesso',
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
