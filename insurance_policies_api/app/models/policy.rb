class Policy < ApplicationRecord
  belongs_to :insured
  belongs_to :vehicle

  enum condition: { waiting_payment: 0, paid: 1 }
end
