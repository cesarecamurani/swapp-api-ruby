# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Products', type: 'request' do
  let(:user) { FactoryBot.create(:user) } 
  let(:swapper) { FactoryBot.create(:swapper, user_id: user.id) }
  let(:item) { FactoryBot.create(:item, swapper_id: swapper.id) }
  let(:wrong_id) { 'WRONG_ID' }

  describe 'GET index' do
    context 'with successful response' do
      let(:second_user) { FactoryBot.create(:user, username: 'mariorossi', email: 'mariorossi@email.com') }
      let(:second_swapper) { FactoryBot.create(:swapper, user_id: second_user.id) }

      before do
        FactoryBot.create(:item, swapper_id: swapper.id)
        FactoryBot.create(:service, swapper_id: swapper.id)
      end
      
      context 'without scopes' do
        it 'returns a list of products' do
          expect(Product).not_to receive(:by_swapper)
          expect(Product).not_to receive(:by_category)

          get '/products/', headers: headers

          expect(response).to have_http_status(:ok)
        end
      end

      context 'scoped by swapper id' do
        it 'returns a list of products scoped by swapper id' do
          expect(Product).to receive(:by_swapper).with(swapper.id)
          
          get '/products/', params: { swapper_id: swapper.id }, headers: headers

          expect(response).to have_http_status(:ok) 
        end
      end

      context 'scoped by category' do
        it 'returns a list of products scoped by category' do
          expect(Product).to receive(:by_category).with(item.category)
          
          get '/products/', params: { category: item.category }, headers: headers
   
          expect(response).to have_http_status(:ok) 
        end
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        get '/products/'

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('Invalid or missing token')
      end
    end
  end
  
  describe 'GET show' do
    context 'with successful response' do
      it 'returns the requested product' do
        get "/products/#{item.id}", headers: headers
 
        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(products_show_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          get "/products/#{item.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('Invalid or missing token')
        end
      end

      context 'with a non existing product id' do
        it 'returns a not found error' do
          get "/products/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'POST create' do
    context 'with all the right params' do
      it 'returns the newly created product' do
        post '/products', params: product_create_params, headers: headers

        expect(response).to have_http_status(:created)
        expect(response_body).to eq(products_create_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        it 'returns an unprocessable entity error' do
          post '/products', params: product_missing_params, headers: headers
          
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
  
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          post '/products', params: product_create_params

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('Invalid or missing token')
        end
      end
    end
  end

  describe 'PATCH update' do
    context 'with all the right params' do
      it 'returns the product with updated attributes' do
        patch "/products/#{item.id}", params: product_update_params, headers: headers
 
        expect(response).to have_http_status(:ok)
        expect(response_body).to eq(products_update_response)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing params' do
        it 'returns an unprocessable entity error' do
          patch "/products/#{item.id}", params: product_missing_params, headers: headers
          
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          patch "/products/#{item.id}", params: product_update_params

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('Invalid or missing token')
        end
      end

      context 'with a non existing product id' do
        it 'returns a not found error' do
          get "/products/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with successful response' do
      it 'returns a 204 no content response' do
        delete "/products/#{item.id}", headers: headers
 
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with unsuccessful response' do
      context 'with missing authentication token' do
        it 'returns an unauthorized error' do
          delete "/products/#{item.id}"

          expect(response).to have_http_status(:unauthorized)
          expect(error_message).to eq('Invalid or missing token')
        end
      end

      context 'with a non existing product id' do
        it 'returns a not found error' do
          get "/products/#{wrong_id}", headers: headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
