# frozen_string_literal: true

FactoryBot.define do
  factory :auction, class: 'Auction' do
    association :swapper
    product_id { SecureRandom.uuid }
    state { 'in_progress' }
    accepted_bid_id { nil }
    expires_at { 72.hours.from_now.strftime('%FT%R:%S.000Z') }
    swapper_id { SecureRandom.uuid }
  end
end
