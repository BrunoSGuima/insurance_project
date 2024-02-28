class RenameColumnsInVehicles < ActiveRecord::Migration[7.0]
  def change
    rename_column :vehicles, :placa, :plate_number
    rename_column :vehicles, :marca, :car_brand
    rename_column :vehicles, :modelo, :model
    rename_column :vehicles, :ano, :year
  end
end