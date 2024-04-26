require 'bunny'
require 'json'
require_relative '../models/application_record'
require_relative '../models/insured'
require_relative '../models/policy'
require_relative '../models/vehicle'

class PolicyWorker
  def work(graphql_policy)

    begin
      policy_data = JSON.parse(graphql_policy)
      issue_date = Date.strptime(policy_data['issue_date'], '%Y-%m-%d')
      coverage_end_date = Date.strptime(policy_data['coverage_end_date'], '%Y-%m-%d')
    rescue Date::Error => e
      puts "Error when parse dates: #{e.message}"
      return
    end

    policy_id = policy_data['policy_id']
    issue_date = Date.parse(policy_data['issue_date'])
    coverage_end_date = Date.parse(policy_data['coverage_end_date'])
    
    insured_name = policy_data['insured']['name']
    insured_itin = policy_data['insured']['itin']
    
    vehicle_plate_number = policy_data['vehicle']['plate_number']
    vehicle_car_brand = policy_data['vehicle']['car_brand']
    vehicle_model = policy_data['vehicle']['model']
    vehicle_year = policy_data['vehicle']['year']
    
    insured = Insured.find_or_create_by(itin: insured_itin) do |insured|
      insured.name = insured_name
    end
    
    vehicle = Vehicle.find_or_create_by(plate_number: vehicle_plate_number) do |vehicle|
      vehicle.car_brand = vehicle_car_brand
      vehicle.model = vehicle_model
      vehicle.year = vehicle_year
    end
    
    policy = Policy.create(
      policy_id: policy_id,
      issue_date: issue_date,
      coverage_end_date: coverage_end_date,
      condition: policy_data[:condition],
      payment_id: policy_data[:payment_id],
      payment_link: policy_data[:payment_link],
      insured: insured,
      vehicle: vehicle,
      condition: policy_data['condition'],
      payment_id: policy_data['payment_id'],
      payment_link: policy_data['payment_link']
    )
    
    if policy.persisted?
      puts "Policy saved!"
    else
      puts "Error saving the policy!"
    end
  end
end
