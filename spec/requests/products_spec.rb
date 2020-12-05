# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'Products', type: 'request' do
  let(:user) { create(:user) }
  let(:swapper) { create(:swapper, user_id: user.id) }
  let(:item) { create(:item, swapper_id: swapper.id) }
  let(:wrong_id) { 'WRONG_ID' }

  describe 'GET index' do
    context 'with successful response' do
      before do
        create(:item, swapper_id: swapper.id)
        create(:service, swapper_id: swapper.id)
      end

      context 'without scopes' do
        it 'returns a list of products' do
          expect(Product).not_to receive(:by_swapper)
          expect(Product).not_to receive(:by_category)
          expect(Product).not_to receive(:by_department)

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

      context 'scoped by department' do
        it 'returns a list of products scoped by department' do
          expect(Product).to receive(:by_department).with(item.department)

          get '/products/', params: { department: item.department }, headers: headers

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        get '/products/'

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
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
          expect(error_message).to eq('This token has been revoked')
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
          expect(error_message).to eq('This token has been revoked')
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
          expect(error_message).to eq('This token has been revoked')
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
          expect(error_message).to eq('This token has been revoked')
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

  describe 'PUT upload_images' do
    context 'with successful response' do
      it 'uploads the images for a product' do
        put "/products/#{item.id}/upload_images",
        params: { images: image },
        headers: headers

        expect(response).to have_http_status(:ok)
        expect(item.images).to be_attached
        expect(item.images_blobs.first['filename']).to eq('image.jpg')
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        put "/products/#{item.id}/upload_images",
        params: { images: image }

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end
  end

  describe 'GET remove_image' do
    let(:upload_images_request) do
      put "/products/#{item.id}/upload_images",
      params: { images: image },
      headers: headers
    end

    let(:image_id) { item.images_blobs.first['id'] }

    before { upload_images_request }

    context 'with successful response' do
      it 'removes the product\'s image' do
        get "/products/#{item.id}/remove_image/#{image_id}",
        headers: headers

        expect(response).to have_http_status(:no_content)
        expect(item.images).not_to be_attached
      end
    end

    context 'with missing authentication token' do
      it 'returns an unauthorized error' do
        get "/products/#{item.id}/remove_image/#{image_id}"

        expect(response).to have_http_status(:unauthorized)
        expect(error_message).to eq('This token has been revoked')
      end
    end
  end
end
