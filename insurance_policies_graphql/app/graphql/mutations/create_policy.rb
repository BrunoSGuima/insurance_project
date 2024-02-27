require_dependency "#{Rails.root}/app/services/bunny_publisher"

module Mutations
  class CreatePolicy < BaseMutation

    argument :policy_id, Integer, required: true
    argument :data_emissao, GraphQL::Types::ISO8601Date, required: true
    argument :data_fim_cobertura, GraphQL::Types::ISO8601Date, required: true
    argument :segurado_nome, String, required: true
    argument :segurado_cpf, String, required: true
    argument :veiculo_marca, String, required: true
    argument :veiculo_modelo, String, required: true
    argument :veiculo_ano, Integer, required: true
    argument :veiculo_placa, String, required: true

    field :status, String, null: false

    def resolve(policy_id:, data_emissao:, data_fim_cobertura:, segurado_nome:, segurado_cpf:, veiculo_marca:, veiculo_modelo:, veiculo_ano:, veiculo_placa:)


      policy_data = {
        policy_id: policy_id,
        data_emissao: data_emissao,
        data_fim_cobertura: data_fim_cobertura,
        segurado: {
          nome: segurado_nome,
          cpf: segurado_cpf
        },
        veiculo: {
          marca: veiculo_marca,
          modelo: veiculo_modelo,
          ano: veiculo_ano,
          placa: veiculo_placa
        }
      }
      puts "-------------- POLICY_DATA: -----------------"
      puts policy_data.to_json

      BunnyPublisher.new.publish(data: policy_data.to_json, queue: 'policies')
      
      { status: "OK" }
    end
  end
end

