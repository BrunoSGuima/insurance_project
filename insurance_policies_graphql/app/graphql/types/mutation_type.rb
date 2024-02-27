module Types
  class MutationType < Types::BaseObject
    field :create_policy, mutation: Mutations::CreatePolicy
  end
end

