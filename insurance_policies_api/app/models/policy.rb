class Policy < ApplicationRecord
  belongs_to :insured
  belongs_to :vehicle
end
