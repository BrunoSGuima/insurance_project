class GraphqlService
  include HTTParty
  base_uri 'http://localhost:3000'

  def self.get_policies(jwt_token)
    query = <<-GRAPHQL
      query getPolicies($jwtToken: String!) {
        getPolicies(jwtToken: $jwtToken) {
          policyId
          issueDate
          coverageEndDate
          insuredName
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
    
    puts response.body
    JSON.parse(response.body)["data"]["getPolicies"]
  end
  
end
