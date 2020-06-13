# frozen_string_literal: true

FactoryBot.define do
  factory :auction, class: 'Auction' do
    association :swapper
    product_id { SecureRandom.uuid }
    state { 'in_progress' }
    offered_products_ids { [] }
    accepted_product_id { '' }
    expires_at { 72.hours.from_now }
    swapper_id { SecureRandom.uuid }
  end
end
