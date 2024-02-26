class CreateUsuarioPixes < ActiveRecord::Migration[7.1]
  def change
    create_table :usuario_pixes do |t|
      t.integer :id_usuario
      t.string :chave_pix
      t.string :tipo_chave
      t.float :saldo
      t.boolean :chave_ativa

      t.timestamps
    end
  end
end
