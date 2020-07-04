# frozen_string_literal: true

FactoryBot.define do
  factory :bid, class: 'Bid' do
    association :auction
    product_id { SecureRandom.uuid }
    state { 'initial' }
  end
end
