# frozen_string_literal: true

module BidsHelpers

  def bid_create_params
    {
      bid: {
        product_id: second_product.id,
        state: 'initial',
        auction_id: auction.id
      }
    }
  end

  def bid_missing_params
    {
      bid: {
        product_id: '',
        state: 'initial',
        auction_id: auction.id
      }
    }
  end

  def bids_show_response
    {
      'object' => {
        'id' => bid.id,
        'product_id' => second_product.id,
        'state' => 'initial',
        'auction_id' => auction.id
      }
    }
  end

  def bids_create_response
    {
      'object' => {
        'id' => Bid.last.id,
        'product_id' => second_product.id,
        'state' => 'initial',
        'auction_id' => auction.id
      }
    }
  end
end
