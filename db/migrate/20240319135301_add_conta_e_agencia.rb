class AddContaEAgenciaEBanco < ActiveRecord::Migration[7.1]
  def change
    add_column :usuario, :conta, :string
    add_column :usuario, :agencia, :string
    add_column :usuario, :banco, :string
  end
end
