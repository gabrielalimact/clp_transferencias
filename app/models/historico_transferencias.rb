class HistoricoTransferencias < ApplicationRecord
  validates :id_usuario, presence: true
  validates :origem_usuario, presence: true
  validates :destino_usuario, presence: true
  validates :valor_transferencia, presence: true
  validates :tipo_transferencia, presence: true
end
