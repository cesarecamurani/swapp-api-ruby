# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'User' do
    username { 'johnsmith' }
    email { 'johnsmith@email.com' }
    password { '@Password1' }
  end
end
  
