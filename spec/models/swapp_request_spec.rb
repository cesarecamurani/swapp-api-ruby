# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe SwappRequest, type: :model do
  let(:user) { create(:user) }
  let(:swapper) { create(:swapper, user_id: user.id) }
  let(:offered_item) { create(:item, swapper_id: swapper.id) }

  let(:second_user) do
    create(:user, username: 'hansgruber', email: 'hansgruber@email.com')
  end

  let(:req_product_owner) do
    create(:swapper, user_id: second_user.id)
  end

  let(:requested_item) { create(:item, swapper_id: req_product_owner.id) }
  
  subject(:swapp_request) do 
    described_class.new(
      status: 'initial',
      swapper_id: swapper.id,
      offered_product_id: offered_item.id,
      requested_product_id: requested_item.id,
      req_product_owner_id: req_product_owner.id
    )
  end

  let(:first_swapp_request) do
    SwappRequest.create!(
      status: 'initial',
      swapper_id: swapper.id,
      offered_product_id: offered_item.id,
      requested_product_id: requested_item.id,
      req_product_owner_id: req_product_owner.id
    )
  end

  let(:second_swapp_request) do
    SwappRequest.create!(
      status: 'rejected',
      swapper_id: req_product_owner.id,
      offered_product_id: requested_item.id,
      requested_product_id: offered_item.id,
      req_product_owner_id: swapper.id
    )
  end

  describe 'Validations' do
    context 'valid' do
      it 'is valid with valid attributes' do
        expect(subject).to be_valid
      end
    end
    
    context 'invalid' do
      it 'is not valid without a status' do
        subject.status = nil
        expect(subject).to_not be_valid
      end

      it 'is not valid without an offered_product_id' do
        subject.offered_product_id = nil
        expect(subject).to_not be_valid
      end
  
      it 'is not valid without a requested_product_id' do
        subject.requested_product_id = nil
        expect(subject).to_not be_valid
      end

      it 'is not valid without a req_product_owner_id' do
        subject.req_product_owner_id = nil
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Scopes' do
    context 'by_status' do
      it 'only shows swapp_requests for the requested status' do
        expect(SwappRequest.by_status(first_swapp_request.status)).to include(first_swapp_request)
        expect(SwappRequest.by_status(first_swapp_request.status)).not_to include(second_swapp_request)
      end
    end

    context 'received' do
      it 'only shows received swapp_requests' do
        expect(SwappRequest.received(swapper.id)).to include(second_swapp_request)
        expect(SwappRequest.received(swapper.id)).not_to include(first_swapp_request)
      end
    end
  end
end
