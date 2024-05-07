class AddPaymentDetailsToPolicies < ActiveRecord::Migration[7.0]
  def change
    add_column :policies, :status, :integer, default: 0
    add_column :policies, :payment_id, :string
    add_column :policies, :payment_link, :string
  end
end
