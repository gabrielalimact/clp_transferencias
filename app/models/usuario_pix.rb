class UsuarioPix < ApplicationRecord
  validates :chave_pix, presence: true
  validates :id_usuario, presence: true
  validates :tipo_chave, presence: true
  validates :saldo, presence: true
  validates :chave_ativa, presence: true
end
