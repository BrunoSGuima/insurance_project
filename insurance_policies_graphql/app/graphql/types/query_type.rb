# frozen_string_literal: true
# require 'httparty'

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

    field :get_policy, Types::PolicyType, null: true, description: "Recebendo uma apólice pelo ID" do
       argument :policy_id, ID, required: true, description: "ID da apólice"
     end


     def get_policy(policy_id:)
      response = HTTParty.get("http://secondapp:4000/policies/#{policy_id}")
      json_response = JSON.parse(response.body)
    
      {
        policy_id: json_response["policy_id"],
        data_emissao: json_response["data_emissao"],
        data_fim_cobertura: json_response["data_fim_cobertura"],
        segurado_nome: json_response["insured"]["nome"],
        segurado_cpf: json_response["insured"]["cpf"],
        veiculo_marca: json_response["vehicle"]["marca"],
        veiculo_modelo: json_response["vehicle"]["modelo"],
        veiculo_ano: json_response["vehicle"]["ano"],
        veiculo_placa: json_response["vehicle"]["placa"],
      }
    end
    
  end
end
