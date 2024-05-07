module Types
  class PolicyType < Types::BaseObject
    field :policy_id, ID, null: false
    field :issue_date, GraphQL::Types::ISO8601Date, null: true
    field :coverage_end_date, GraphQL::Types::ISO8601Date, null: true
    field :insured_name, String, null: false
    field :insured_itin, String, null: false
    field :condition, String, null: false
    field :payment_id, String, null: true
    field :payment_link, String, null: true
    field :vehicle_car_brand, String, null: false
    field :vehicle_model, String, null: false
    field :vehicle_year, Integer, null: false
    field :vehicle_plate_number, String, null: false 
  end
end
