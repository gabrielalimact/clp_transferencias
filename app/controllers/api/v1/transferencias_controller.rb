module Api
  module V1
    class TransferenciasController < ApplicationController
      def create
        id_origem = params[:id_origem]
        id_destino = params[:id_destino]
        valor_transferencia = params[:valor].to_f

        usuario_origem = UsuarioPix.find(id_origem)
        usuario_destino = UsuarioPix.find(id_destino)

        # Verifica se o valor da transferência é maior que zero
        if valor_transferencia <= 0
          render json: { error: 'O valor da transferência deve ser maior que zero' }, status: :unprocessable_entity
          return
        end

        # Verifica se o valor da transferência é menor ou igual ao saldo do usuário de origem
        if valor_transferencia > usuario_origem.saldo
          render json: { error: 'Saldo insuficiente' }, status: :unprocessable_entity
          return
        end

        # Realiza a transferência
        ActiveRecord::Base.transaction do
          usuario_origem.update(saldo: usuario_origem.saldo - valor_transferencia)
          usuario_destino.update(saldo: usuario_destino.saldo + valor_transferencia)
        end

        render json: {
                      status: 'success',
                      message: 'Transferência realizada com sucesso',
                      transferencia: {
                        valor: valor_transferencia,
                        id_origem: id_origem,
                        id_destino: id_destino,
                        data: Time.now
                      }
                    }, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Usuário não encontrado' }, status: :not_found
      end
    end
  end
end
