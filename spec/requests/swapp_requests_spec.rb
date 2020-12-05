# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'SwappRequests', type: 'request' do
  let(:user) { create(:user) }

  let(:second_user) do
    create(:user, username: 'hans.gruber', email: 'hans.gruber@email.com')
  end

  let(:third_user) do
    create(:user, username: 'john.mc.clane', email: 'john.mc.clane@email.com')
  end

  let(:swapper) { create(:swapper, user_id: user.id) }

  let(:req_product_owner) do
    create(:swapper, user_id: second_user.id)
  end

  let(:third_swapper) do
    create(:swapper, user_id: third_user.id)
  end

  let(:offered_item) { create(:item, swapper_id: swapper.id) }
  let(:requested_item) { create(:item, swapper_id: req_product_owner.id) }
  let(:third_item) { create(:item, swapper_id: third_swapper.id) }

  let(:swapp_request) do
    create(
      :swapp_request,
      swapper_id: swapper.id,
      offered_product_id: offered_item.id,
      requested_product_id: requested_item.id,
      req_product_owner_id: req_product_owner.id
    )
  end

  let(:second_swapp_request) do
    create(
      :swapp_request,
      swapper_id: third_swapper.id,
      offered_product_id: third_item.id,
      requested_product_id: requested_item.id,
      req_product_owner_id: req_product_owner.id
    )
  end

  let(:wrong_id) { 'WRONG_ID' }

  describe 'GET index' do
    context 'with successful response' do
      before do
        create(:swapp_request, swapper_id: swapper.id)
      end

      context 'without scopes' do
        it 'returns a list of swapp_requests' do
          expect(SwappRequest).not_to receive(:by_state)
          expect(SwappRequest).to receive(:received)

          get '/swapp_requests/', headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by state' do
        it 'returns a list of swapp_requests scoped by state' do
          expect(SwappRequest).to receive(:by_state).with(swapp_request.state)

          get '/swapp_requests/', params: { state: swapp_request.state }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by received requests' do
        it 'returns a list of swapp_requests scoped by received requests' do
          expect(SwappRequest).to receive(:received).with(swapper.id)

          get '/swapp_requests/', params: { swapper_id: swapper.id }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        get '/swapp_requests/'

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end
  end

  describe 'GET show' do
    context 'with successful response' do
      it 'returns the requested swapp_request' do
        get "/swapp_requests/#{swapp_request.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(swapp_requests_show_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          get "/swapp_requests/#{swapp_request.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing swapp_request id' do
        it 'returns a not found error' do
          get "/swapp_requests/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with another swapper\'s swapp_request id' do
        it 'returns a not found error' do
          get "/swapp_requests/#{second_swapp_request.id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST create' do
    context 'with all the right params' do
      it 'returns the newly created swapp_request' do
        post '/swapp_requests', params: swapp_request_create_params, headers: headers

        expect(response).to have_http_status(:created)
        expect(response_body).to eq(swapp_requests_create_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        it 'returns an unprocessable entity error' do
          post '/swapp_requests', params: swapp_request_missing_params, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          post '/swapp_requests', params: swapp_request_create_params

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with successful response' do
      it 'returns a 204 no content response' do
        delete "/swapp_requests/#{swapp_request.id}", headers: headers

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          delete "/swapp_requests/#{swapp_request.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing swapp_request id' do
        it 'returns a not found error' do
          get "/swapp_requests/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with another swapper\'s swapp_request id' do
        it 'returns a not found error' do
          get "/swapp_requests/#{second_swapp_request.id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'PATCH accept_swapp_request' do
    context 'with successful response' do
      it 'changes the swapp_request state to accepted' do
        patch "/swapp_requests/#{swapp_request.id}/accept_swapp_request",
        headers: headers

        expect(response).to have_http_status(:ok)
        expect(state).to eq('accepted')
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        patch "/swapp_requests/#{swapp_request.id}/accept_swapp_request"

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end

    context 'with another swapper\'s swapp_request id' do
      it 'returns a not found error' do
        patch "/swapp_requests/#{second_swapp_request.id}/accept_swapp_request",
        headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH reject_swapp_request' do
    context 'with successful response' do
      it 'changes the swapp_request state to rejected' do
        patch "/swapp_requests/#{swapp_request.id}/reject_swapp_request",
        headers: headers

        expect(response).to have_http_status(:ok)
        expect(state).to eq('rejected')
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        patch "/swapp_requests/#{swapp_request.id}/reject_swapp_request"

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end

    context 'with another swapper\'s swapp_request id' do
      it 'returns a not found error' do
        patch "/swapp_requests/#{second_swapp_request.id}/reject_swapp_request",
        headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
