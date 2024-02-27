module Types
  class PolicyType < Types::BaseObject
    field :policy_id, ID, null: false
    field :data_emissao, GraphQL::Types::ISO8601Date, null: true
    field :data_fim_cobertura, GraphQL::Types::ISO8601Date, null: true
    field :segurado_nome, String, null: false
    field :segurado_cpf, String, null: false
    field :veiculo_marca, String, null: false
    field :veiculo_modelo, String, null: false
    field :veiculo_ano, Integer, null: false
    field :veiculo_placa, String, null: false 
  end
end
