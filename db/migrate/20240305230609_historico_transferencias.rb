class HistoricoTransferencias < ActiveRecord::Migration[7.1]
  def change
    create_table :historico_transferencias do |t|
      t.integer :id_usuario
      t.string :origem_usuario
      t.string :destino_usuario
      t.string :tipo_transferencia
      t.float :valor_transferencia

      t.timestamps
    end
  end
end
