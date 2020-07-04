# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe Bid, type: :model do
  let(:user) { create(:user) }
  let(:swapper) { create(:swapper, user_id: user.id) }
  let(:product) { create(:item, swapper_id: swapper.id) }
  let(:auction) { create(:auction, swapper_id: swapper.id) }

  subject(:bid) do 
    described_class.new(
      product_id: product.id,
      state: 'initial',
      auction_id: auction.id
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
    end
  end
end
