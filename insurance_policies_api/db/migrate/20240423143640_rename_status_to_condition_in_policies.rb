class RenameStatusToConditionInPolicies < ActiveRecord::Migration[7.0]
  def change
      rename_column :policies, :status, :condition
  end
end
