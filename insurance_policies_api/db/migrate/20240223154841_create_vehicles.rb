class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :placa
      t.string :marca
      t.string :modelo
      t.integer :ano

      t.timestamps
    end
  end
end
