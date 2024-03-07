class GraphqlService
  include HTTParty
  base_uri 'http://localhost:3000'

  def self.get_policies
    query = <<-GRAPHQL
      query {
        getPolicies {
          policyId
          issueDate
          coverageEndDate
          insuredName
        }
      }
    GRAPHQL

    response = post("/graphql", body: { query: query }.to_json, headers: { 'Content-Type' => 'application/json' })
    puts response.body
    JSON.parse(response.body)["data"]["getPolicies"]
  end
end
