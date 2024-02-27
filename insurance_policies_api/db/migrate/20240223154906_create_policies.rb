class CreatePolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :policies do |t|
      t.integer :policy_id, null: false, unique: true
      t.date :data_emissao
      t.date :data_fim_cobertura
      t.references :insured, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
    add_index :policies, :policy_id, unique: true
  end
end
