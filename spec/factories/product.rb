# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: 'Product' do
    association :swapper
    swapper_id { SecureRandom.uuid }
    up_for_auction { false }
  end

  factory :item, parent: :product do
    category { 'Product::Item' }
    title { 'BMC Alpenchallenge AC2' }
    description { 'Great hybrid bike ideal for commuting' }
    department { 'Sport and Outdoor' }
  end

  factory :service, parent: :product do
    category { 'Product::Service' }
    title { 'Chef for hire' }
    description { 'Amazing private Chef will delight your guests' }
    department { 'Hospitality Services' }
  end
end
