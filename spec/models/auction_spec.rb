# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Auction, type: :model do
  let(:user) { create(:user) }
  let(:swapper) { create(:swapper, user_id: user.id) }
  
  let(:second_user) do
    create(
      :user,
      username: 'tizioqualunque',
      email: 'tizioqualunque@email.com'
    )
  end

  let(:second_swapper) do
    create(
      :swapper, 
      user_id: second_user.id
    )
  end

  let(:product) { create(:item, swapper_id: swapper.id) }
  let(:second_product) { create(:item, swapper_id: second_swapper.id) }

  subject(:auction) do 
    described_class.new(
      product_id: product.id,
      state: 'in_progress',
      accepted_bid_id: '',
      expires_at: 72.hours.from_now,
      swapper_id: swapper.id
    )
  end

  let(:first_auction) do
    Auction.create!(
      product_id: product.id,
      state: 'in_progress',
      expires_at: 72.hours.from_now,
      swapper_id: swapper.id
    )
  end

  let(:second_auction) do
    Auction.create!(
      product_id: second_product.id,
      state: 'closed',
      expires_at: 72.hours.from_now,
      swapper_id: second_swapper.id
    )
  end

  describe 'Validations' do
    context 'valid' do
      it 'is valid with valid attributes' do
        expect(subject).to be_valid
      end  
    end
    
    context 'invalid' do
      it 'is not valid without a product id' do
        subject.product_id = nil
        expect(subject).to_not be_valid
      end
  
      it 'is not valid without a state' do
        subject.state = nil
        expect(subject).to_not be_valid
      end
  
      it 'is not valid without a expires_at' do
        subject.expires_at = nil
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'Scopes' do
    context 'by_swapper' do
      it 'only shows auctions for the requested swapper' do
        expect(Auction.by_swapper(swapper.id)).to include(first_auction)
        expect(Auction.by_swapper(swapper.id)).not_to include(second_auction)
      end
    end
  
    context 'by_category' do
      it 'only shows auctions for the requested state' do
        expect(Auction.by_state(first_auction.state)).to include(first_auction)
        expect(Auction.by_state(first_auction.state)).not_to include(second_auction)
      end
    end
  end
end
