class RenameColumnsInPolicies < ActiveRecord::Migration[7.0]
  def change
    rename_column :policies, :data_emissao, :issue_date
    rename_column :policies, :data_fim_cobertura, :coverage_end_date
  end
end
