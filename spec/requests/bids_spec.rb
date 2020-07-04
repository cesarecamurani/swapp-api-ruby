# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Bids', type: 'request' do
  let(:user) { create(:user) }
  let(:second_user) do
    create(
      :user,
      username: 'qualcuno',
      email: 'qualcuno@email.com'
    )
  end
  
  let(:swapper) { create(:swapper, user_id: user.id) }
  let(:second_swapper) do
    create(
      :swapper, 
      user_id: second_user.id
    )
  end
  
  let(:product) { create(:item, swapper_id: swapper.id) }
  let(:second_product) { create(:item, swapper_id: second_swapper.id) }

  let(:auction) do 
    create(:auction, product_id: product.id, swapper_id: swapper.id)
  end
  
  let(:bid) do 
    create(:bid, product_id: second_product.id, auction_id: auction.id)
  end

  let(:wrong_id) { 'WRONG_ID' }

  describe 'GET summary' do
    context 'with successful response' do
      before do
        create(:bid, auction_id: auction.id)
      end
    
      it 'returns a list of bids' do
        get '/bids/summary', params: { auction_id: auction.id }, headers: headers

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        get '/bids/summary', params: { auction_id: auction.id }

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('Invalid or missing token')
      end
    end
  end
  
  describe 'GET show' do
    context 'with successful response' do
      it 'returns the requested bid' do
        get "/bids/#{bid.id}", params: { auction_id: auction.id }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(bids_show_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          get "/bids/#{bid.id}", params: { auction_id: auction.id }

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('Invalid or missing token')
        end
      end

      context 'with a non existing bid id' do
        it 'returns a not found error' do
          get "/bids/#{wrong_id}", params: { auction_id: auction.id }, headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST create' do
    context 'with all the right params' do
      it 'returns the newly created bid' do
        post '/bids', params: bid_create_params, headers: headers

        expect(response).to have_http_status(:created)
        expect(response_body).to eq(bids_create_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        it 'returns an unprocessable entity error' do
          post '/bids', params: bid_missing_params, headers: headers
          
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
  
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          post '/bids', params: bid_create_params

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('Invalid or missing token')
        end
      end
    end
  end
end
