# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Authentication', type: 'request' do
  let(:user) { create(:user) }

  describe 'POST login' do
    context 'with valid credentials' do
      it 'returns a valid token' do
        post '/auth/login', params: user_login_params

        expect(response).to have_http_status(:ok)
        expect(response_body['user_id']).to eq(user.id)
        expect(response_body['token_type']).to eq('Bearer')
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized error' do
        post '/auth/login', params: invalid_credentials

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('Invalid credentials!')
      end
    end
  end

  describe 'POST logout' do
    context 'with valid token' do
      it 'returns a logged out message' do
        post '/auth/logout', headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(logout_message)
      end
    end

    context 'with invalid token' do
      it 'returns an unauthorized error' do
        post '/auth/logout'

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('Invalid or missing token')
      end
    end
  end
end
