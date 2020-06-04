# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Users', type: 'request' do
  let(:user) { FactoryBot.create(:user) }
  let(:wrong_id) { 'WRONG_ID' }
  let(:token) { token_for(user.id) }
  let(:headers) do
    {
      "Authorization" => "Bearer #{token}"
    }
  end
  
  describe 'GET show' do
    context 'with successful response' do
      it 'returns the requested user' do
        get "/users/#{user.id}", headers: headers

        details = JSON.parse(response.body)
        
        expect(response).to have_http_status(:ok)
        expect(details['username']).to eq('johnsmith')
        expect(details['email']).to eq('johnsmith@email.com')
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          get "/users/#{user.id}"

          message = JSON.parse(response.body)['message']

          expect(response).to have_http_status(:unauthorized)
          expect(message).to eq('Invalid or missing token')
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
      let(:user_params) do
        {
          user: {
            username: 'testuser',
            email: 'testuser@email.com',
            password: '@Password1'
          }
        }
      end
  
      it 'returns the newly created user' do
        post '/users', params: user_params

        details = JSON.parse(response.body)
        
        expect(response).to have_http_status(:created)
        expect(details['username']).to eq('testuser')
        expect(details['email']).to eq('testuser@email.com')
      end
    end

    context 'with missing params' do
      let(:missing_user_params) do
        {
          user: {
            username: '',
            email: 'testuser@email.com',
            password: '@Password1'
          }
        }
      end
  
      it 'returns an unprocessable entity error' do
        post '/users', params: missing_user_params
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH update' do
    let(:user_params) do
      {
        user: {
          username: 'anotheruser',
          email: 'anotheruser@email.com',
          password: '@Password1'
        }
      }
    end

    context 'with all the right params' do
      it 'returns the user with updated attributes' do
        patch "/users/#{user.id}", params: user_params, headers: headers

        details = JSON.parse(response.body)
        
        expect(response).to have_http_status(:ok)
        expect(details['username']).to eq('anotheruser')
        expect(details['email']).to eq('anotheruser@email.com')
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        let(:missing_user_params) do
          {
            user: {
              username: '',
              email: 'testuser@email.com',
              password: '@Password1'
            }
          }
        end
    
        it 'returns an unprocessable entity error' do
          patch "/users/#{user.id}", params: missing_user_params, headers: headers
          
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          patch "/users/#{user.id}", params: user_params
          
          message = JSON.parse(response.body)['message']

          expect(response).to have_http_status(:unauthorized)
          expect(message).to eq('Invalid or missing token')
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

          message = JSON.parse(response.body)['message']

          expect(response).to have_http_status(:unauthorized)
          expect(message).to eq('Invalid or missing token')
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
