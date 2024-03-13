# frozen_string_literal: true
# require 'httparty'
require 'jwt'

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :get_policy, Types::PolicyType, null: true, description: "Receiveing policy by ID" do
       argument :policy_id, ID, required: true, description: "Policy ID"
     end


     def get_policy(policy_id:)
      response = HTTParty.get("http://secondapp:4000/policies/#{policy_id}")
      json_response = JSON.parse(response.body)
    
      {
        policy_id: json_response["policy_id"],
        issue_date: json_response["issue_date"],
        coverage_end_date: json_response["coverage_end_date"],
        insured_name: json_response["insured"]["name"],
        insured_itin: json_response["insured"]["itin"],
        vehicle_car_brand: json_response["vehicle"]["car_brand"],
        vehicle_model: json_response["vehicle"]["model"],
        vehicle_year: json_response["vehicle"]["year"],
        vehicle_plate_number: json_response["vehicle"]["plate_number"],
      }
    end

    field :get_policies, [Types::PolicyType], null: false do
      argument :jwt_token, String, required: true
    end

    def get_policies(jwt_token:)
      # authenticate_request!(jwt_token)
      response = HTTParty.get("http://secondapp:4000/policies", headers: { "Authorization" => "Bearer #{jwt_token}" })
      json_response = JSON.parse(response.body)
    
      json_response.map do |policy|
        {
          policy_id: policy["policy_id"],
          issue_date: policy["issue_date"],
          coverage_end_date: policy["coverage_end_date"],
          insured_name: policy["insured"]["name"],
          insured_itin: policy["insured"]["itin"],
          vehicle_car_brand: policy["vehicle"]["car_brand"],
          vehicle_model: policy["vehicle"]["model"],
          vehicle_year: policy["vehicle"]["year"],
          vehicle_plate_number: policy["vehicle"]["plate_number"],
        }
      end
    end

    def authenticate_request!(jwt_token)
      jwt_secret = 'secret_key'
      begin
        decoded_token = JWT.decode(jwt_token, jwt_secret, true, { algorithm: 'HS256' })
      rescue JWT::DecodeError => e
        raise GraphQL::ExecutionError.new("Authentication failed: #{e.message}", extensions: { code: 'UNAUTHORIZED' })
      end
    end
    
    
  end
end
