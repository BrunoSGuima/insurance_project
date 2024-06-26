class GraphqlService
  include HTTParty
  base_uri 'http://app:5000'

  def self.get_policies(jwt_token)
    query = <<-GRAPHQL
      query getPolicies($jwtToken: String!) {
        getPolicies(jwtToken: $jwtToken) {
          policyId
          issueDate
          coverageEndDate
          insuredName
          paymentId
          paymentLink
          condition
        }
      }
    GRAPHQL
  
    response = post("/graphql", 
      body: {
        query: query,
        variables: { jwtToken: jwt_token },
    }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
    
    JSON.parse(response.body)["data"]["getPolicies"]
  end

  def self.create_policy(jwt_token, input)
    input[:policyId] = input[:policyId].to_i if input[:policyId]
    input[:vehicleYear] = input[:vehicleYear].to_i if input[:vehicleYear]

    query = <<-GRAPHQL
      mutation CreatePolicy($input: CreatePolicyInput!) {
        createPolicy(input: $input) {
          status
        }
      }
    GRAPHQL

    variables = { input: input }
    response = HTTParty.post(
      "http://app:5000/graphql",
      body: { query: query, variables: variables }.to_json,
      headers: { "Content-Type" => "application/json", "Authorization" => "Bearer #{jwt_token}" }
    )
        
    parsed_response = JSON.parse(response.body)
    if parsed_response["errors"]
      Rails.logger.error("GraphQL Errors: #{parsed_response["errors"]}")
      return { error: parsed_response["errors"] }
    end
  
    parsed_response.dig("data", "createPolicy")
  end
  
  
end
