# frozen_string_literal: true

FactoryBot.define do
  factory :swapp_request, class: 'SwappRequest' do
    association :swapper
    state { 'initial' }
    swapper_id { SecureRandom.uuid }
    offered_product_id { SecureRandom.uuid }
    requested_product_id { SecureRandom.uuid }
    req_product_owner_id { SecureRandom.uuid }
  end
end
