# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Swappers', type: 'request' do
  let(:user) { create(:user) }
  let(:swapper) { create(:swapper, user_id: user.id) }
  let(:wrong_id) { 'WRONG_ID' }

  describe 'GET index' do
    context 'with successful response' do
      let(:second_user) do
        create(:user, username: 'mariorossi', email: 'mariorossi@email.com')
      end

      before do
        create(:swapper, user_id: second_user.id)
      end

      context 'without scopes' do
        it 'returns a list of swappers' do
          expect(Swapper).not_to receive(:by_rating)
          expect(Swapper).not_to receive(:by_username)
          expect(Swapper).not_to receive(:by_email)
          expect(Swapper).not_to receive(:by_city)
          expect(Swapper).not_to receive(:by_country)

          get '/swappers/', headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by rating' do
        it 'returns a list of swappers scoped by rating' do
          expect(Swapper).to receive(:by_rating).with(swapper.rating)

          get '/swappers/', params: { rating: swapper.rating }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by username' do
        it 'returns a list of swappers scoped by username' do
          expect(Swapper).to receive(:by_username).with(swapper.username)

          get '/swappers/', params: { username: swapper.username }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by email' do
        it 'returns a list of swappers scoped by email' do
          expect(Swapper).to receive(:by_email).with(swapper.email)

          get '/swappers/', params: { email: swapper.email }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by city' do
        it 'returns a list of swappers scoped by city' do
          expect(Swapper).to receive(:by_city).with(swapper.city)

          get '/swappers/', params: { city: swapper.city }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by country' do
        it 'returns a list of swappers scoped by country' do
          expect(Swapper).to receive(:by_country).with(swapper.country)

          get '/swappers/', params: { country: swapper.country }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        get '/swappers/'

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end
  end

  describe 'GET show' do
    context 'with successful response' do
      it 'returns the requested swapper' do
        get "/swappers/#{swapper.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(swappers_show_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          get "/swappers/#{swapper.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing swapper id' do
        it 'returns a not found error' do
          get "/swappers/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST create' do
    context 'with all the right params' do
      it 'returns the newly created swapper' do
        post '/swappers', params: swapper_create_params, headers: headers

        expect(response).to have_http_status(:created)
        expect(response_body).to eq(swappers_create_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        it 'returns an unprocessable entity error' do
          post '/swappers', params: swapper_missing_params, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          post '/swappers', params: swapper_create_params

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end
    end
  end

  describe 'PATCH update' do
    context 'with all the right params' do
      it 'returns the swapper with updated attributes' do
        patch "/swappers/#{swapper.id}", params: swapper_update_params, headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(swappers_update_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        it 'returns an unprocessable entity error' do
          patch "/swappers/#{swapper.id}", params: swapper_missing_params, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          patch "/swappers/#{swapper.id}", params: swapper_update_params

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing swapper id' do
        it 'returns a not found error' do
          get "/swappers/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with successful response' do
      it 'returns a 204 no content response' do
        delete "/swappers/#{swapper.id}", headers: headers

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          delete "/swappers/#{swapper.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing swapper id' do
        it 'returns a not found error' do
          get "/swappers/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'PUT upload_avatar' do
    context 'with successful response' do
      it 'uploads the avatar for a swapper' do
        put "/swappers/#{swapper.id}/upload_avatar",
        params: { avatar: avatar },
        headers: headers

        expect(response).to have_http_status(:ok)
        expect(swapper.avatar).to be_attached
        expect(swapper.avatar_blob['filename']).to eq('avatar.jpg')
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        put "/swappers/#{swapper.id}/upload_avatar",
        params: { avatar: avatar }

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end
  end

  describe 'GET remove_avatar' do
    let(:upload_avatar_request) do
      put "/swappers/#{swapper.id}/upload_avatar",
      params: { avatar: avatar },
      headers: headers
    end

    before { upload_avatar_request }

    context 'with successful response' do
      it 'removes the swapper\'s avatar' do
        get "/swappers/#{swapper.id}/remove_avatar",
        headers: headers

        expect(response).to have_http_status(:no_content)
        expect(swapper.avatar).not_to be_attached
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        get "/swappers/#{swapper.id}/remove_avatar"

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end
  end
end
