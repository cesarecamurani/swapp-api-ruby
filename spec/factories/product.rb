# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: 'Product' do
    association :swapper
    swapper_id { SecureRandom.uuid }
    up_for_auction { false }
  end

  factory :item, class: 'Product::Item', parent: :product do
    category { 'Product::Item' }
    title { 'BMC Alpenchallenge AC2' }
    description { 'Great hybrid bike ideal for commuting' }
  end

  factory :service, class: 'Product::Service', parent: :product do
    category { 'Product::Service' }
    title { 'Chef for hire' }
    description { 'Amazing private Chef will delight your guests' }
  end
end
