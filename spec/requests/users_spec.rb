# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Users', type: 'request' do
  let(:user) { create(:user) }
  let(:wrong_id) { 'WRONG_ID' }

  describe 'GET show' do
    context 'with successful response' do
      it 'returns the requested user' do
        get "/users/#{user.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(users_show_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          get "/users/#{user.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing user id' do
        it 'returns a not found error' do
          get "/users/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST create' do
    context 'with all the right params' do
      it 'returns the newly created user' do
        post '/users', params: user_create_params

        expect(response).to have_http_status(:created)
        expect(response_body).to eq(users_create_response)
      end
    end

    context 'with missing params' do
      it 'returns an unprocessable entity error' do
        post '/users', params: user_missing_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH update' do
    context 'with all the right params' do
      it 'returns the user with updated attributes' do
        patch "/users/#{user.id}", params: user_update_params, headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(users_update_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        it 'returns an unprocessable entity error' do
          patch "/users/#{user.id}", params: user_missing_params, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          patch "/users/#{user.id}", params: user_update_params

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing user id' do
        it 'returns a not found error' do
          get "/users/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with successful response' do
      it 'returns a 204 no content response' do
        delete "/users/#{user.id}", headers: headers

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          delete "/users/#{user.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing user id' do
        it 'returns a not found error' do
          get "/users/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
