class UsuarioPix < ApplicationRecord
  validates :conta, presence: true
  validates :agencia, presence: true
  validates :chave_pix, presence: true
  validates :id_usuario, presence: true
  validates :tipo_chave, presence: true
  validates :saldo, presence: true
  validates :chave_ativa, presence: true
end
