require_dependency "#{Rails.root}/app/services/bunny_publisher"

module Mutations
  class CreatePolicy < BaseMutation

    argument :policy_id, Integer, required: true
    argument :issue_date, GraphQL::Types::ISO8601Date, required: true
    argument :coverage_end_date, GraphQL::Types::ISO8601Date, required: true
    argument :insured_name, String, required: true
    argument :insured_itin, String, required: true
    argument :vehicle_car_brand, String, required: true
    argument :vehicle_model, String, required: true
    argument :vehicle_year, Integer, required: true
    argument :vehicle_plate_number, String, required: true

    field :status, String, null: false

    def resolve(policy_id:, issue_date:, coverage_end_date:, insured_name:, insured_itin:, vehicle_car_brand:, vehicle_model:, vehicle_year:, vehicle_plate_number:)


      policy_data = {
        policy_id: policy_id,
        issue_date: issue_date,
        coverage_end_date: coverage_end_date,
        insured: {
          name: insured_name,
          itin: insured_itin
        },
        vehicle: {
          car_brand: vehicle_car_brand,
          model: vehicle_model,
          year: vehicle_year,
          plate_number: vehicle_plate_number
        }
      }

      BunnyPublisher.new.publish(data: policy_data.to_json, queue: 'policies')
      
      { status: "OK" }
    end
  end
end

