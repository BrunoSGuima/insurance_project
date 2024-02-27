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
      data_emissao = Date.strptime(policy_data['data_emissao'], '%Y-%m-%d')
      data_fim_cobertura = Date.strptime(policy_data['data_fim_cobertura'], '%Y-%m-%d')
    rescue Date::Error => e
      puts "Erro ao fazer o parse das datas: #{e.message}"
      return
    end

    # Extrair dados da apólice
    policy_id = policy_data['policy_id']
    data_emissao = Date.parse(policy_data['data_emissao'])
    data_fim_cobertura = Date.parse(policy_data['data_fim_cobertura'])
    
    # Extrair dados do segurado
    insured_nome = policy_data['segurado']['nome']
    insured_cpf = policy_data['segurado']['cpf']
    
    # Extrair dados do veículo
    vehicle_placa = policy_data['veiculo']['placa']
    vehicle_marca = policy_data['veiculo']['marca']
    vehicle_modelo = policy_data['veiculo']['modelo']
    vehicle_ano = policy_data['veiculo']['ano']
    
    # Buscar ou criar o segurado no banco de dados
    insured = Insured.find_or_create_by(cpf: insured_cpf) do |insured|
      insured.nome = insured_nome
    end
    
    # Buscar ou criar o veículo no banco de dados
    vehicle = Vehicle.find_or_create_by(placa: vehicle_placa) do |vehicle|
      vehicle.marca = vehicle_marca
      vehicle.modelo = vehicle_modelo
      vehicle.ano = vehicle_ano
    end
    
    # Criar a apólice associando o segurado e o veículo
    policy = Policy.create(
      policy_id: policy_id,
      data_emissao: data_emissao,
      data_fim_cobertura: data_fim_cobertura,
      insured: insured,
      vehicle: vehicle
    )
    
    # Verificar se a apólice foi salva com sucesso
    if policy.persisted?
      puts "Apólice salva com sucesso!"
    else
      puts "Erro ao salvar a apólice!"
    end
  end
end
