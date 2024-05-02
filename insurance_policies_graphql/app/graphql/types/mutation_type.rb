module Types
  class MutationType < Types::BaseObject
    field :create_policy, mutation: Mutations::CreatePolicy
    field :update_payment,  mutation: Mutations::UpdatePaymentMutation
  end
end

