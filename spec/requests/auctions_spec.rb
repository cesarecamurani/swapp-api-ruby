# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Auctions', type: 'request' do
  let(:user) { create(:user) }
  let(:swapper) { create(:swapper, user_id: user.id) }
  let(:product) { create(:item, swapper_id: swapper.id) }
  let(:auction) do
    create(:auction, product_id: product.id, swapper_id: swapper.id)
  end

  let(:wrong_id) { 'WRONG_ID' }

  describe 'GET index' do
    context 'with successful response' do
      before do
        create(:auction, swapper_id: swapper.id)
      end

      context 'without scopes' do
        it 'returns a list of auctions' do
          expect(Auction).not_to receive(:by_swapper)
          expect(Auction).not_to receive(:by_state)

          get '/auctions/', headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by swapper id' do
        it 'returns a list of auctions scoped by received requests' do
          expect(Auction).to receive(:by_swapper).with(swapper.id)

          get '/auctions/', params: { swapper_id: swapper.id }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by state' do
        it 'returns a list of auctions scoped by state' do
          expect(Auction).to receive(:by_state).with(auction.state)

          get '/auctions/', params: { state: auction.state }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        get '/auctions/'

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end
  end

  describe 'GET show' do
    context 'with successful response' do
      it 'returns the requested auction' do
        get "/auctions/#{auction.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(auctions_show_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          get "/auctions/#{auction.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing auction id' do
        it 'returns a not found error' do
          get "/auctions/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST create' do
    context 'with all the right params' do
      it 'returns the newly created auction' do
        post '/auctions', params: auction_create_params, headers: headers

        expect(response).to have_http_status(:created)
        expect(response_body).to eq(auctions_create_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        it 'returns an unprocessable entity error' do
          post '/auctions', params: auction_missing_params, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          post '/auctions', params: auction_create_params

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with successful response' do
      it 'returns a 204 no content response' do
        delete "/auctions/#{auction.id}", headers: headers

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          delete "/auctions/#{auction.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('This token has been revoked')
        end
      end

      context 'with a non existing auction id' do
        it 'returns a not found error' do
          get "/auctions/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
