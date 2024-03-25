class CreateUsuarios < ActiveRecord::Migration[7.1]
  def change
    create_table :usuario do |t|
      t.integer :conta
      t.integer :agencia
      t.integer :id_usuario
      t.string :chave_pix
      t.string :tipo_chave
      t.float :saldo
      t.boolean :chave_ativa

      t.timestamps
    end
  end
end
