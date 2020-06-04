# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Authentication', type: 'request' do
  let(:user) { FactoryBot.create(:user) }
  let(:user_params) do
    {
      email: user.email,
      password: user.password
    }
  end

  let(:token) { token_for(user.id) }
  let(:headers) do
    {
      "Authorization" => "Bearer #{token}"
    }
  end

  describe 'POST login' do
    context 'with valid credentials' do
      it 'returns a valid token' do
        post '/auth/login', params: user_params

        auth_response = JSON.parse(response.body)
        
        expect(response).to have_http_status(:ok)
        expect(auth_response['token_type']).to eq('Bearer')
        expect(auth_response['user_id']).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      let(:invalid_credentials) do
        {
          email: '',
          password: user.password
        }
      end

      it 'returns an unauthorized error' do
        post '/auth/login', params: invalid_credentials

        message = JSON.parse(response.body)['message']

        expect(response).to have_http_status(:unauthorized)
        expect(message).to eq('Invalid credentials')
      end
    end
  end

  describe 'POST logout' do
    let(:logout_message) { { 'message' => 'You\'ve been logged out' } }
    
    context 'with valid token' do
      it 'returns a logged out message' do
        post '/auth/logout', headers: headers

        message = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(message).to eq(logout_message)
      end
    end

    context 'with invalid token' do
      it 'returns an unauthorized error' do
        post '/auth/logout'

        message = JSON.parse(response.body)['message']

        expect(response).to have_http_status(:unauthorized)
        expect(message).to eq('Invalid or missing token')
      end
    end
  end
end
