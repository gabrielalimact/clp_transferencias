class AddContaEAgencia < ActiveRecord::Migration[7.1]
  def change
    add_column :usuario_pixes, :conta, :string
    add_column :usuario_pixes, :agencia, :string
  end
end
