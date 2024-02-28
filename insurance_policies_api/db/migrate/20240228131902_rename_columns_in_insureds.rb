class RenameColumnsInInsureds < ActiveRecord::Migration[7.0]
  def change
    rename_column :insureds, :nome, :name
    rename_column :insureds, :cpf, :itin
  end
end