# frozen_string_literal: true

FactoryBot.define do
  factory :swapper, class: 'Swapper' do
    association :user
    name { 'John' }
    surname { 'Smith' }
    email { 'johnsmith@email.com' }
    date_of_birth { '06-06-1966' }
    phone_number { '07712345678' }
    address { '6, Street' }
    city { 'London' }
    country { 'UK' }
    user_id { SecureRandom.uuid }
  end
end
