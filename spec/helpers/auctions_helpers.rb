# frozen_string_literal: true

module AuctionsHelpers

  def auction_create_params
    {
      auction: {
        product_id: product.id,
        state: 'in_progress',
        expires_at: 72.hours.from_now.strftime('%F %R:%S'),
        swapper_id: swapper.id
      }
    }
  end

  def auction_missing_params
    {
      auction: {
        product_id: '',
        state: 'in_progress',
        expires_at: 72.hours.from_now,
        swapper_id: swapper.id
      }
    }
  end

  def auctions_show_response
    {
      'id' => auction.id,
      'product_id' => product.id,
      'accepted_bid_id' => nil,
      'state' => 'in_progress',
      'expires_at' => auction.expires_at.strftime('%FT%R:%S.000Z'),
      'swapper_id' => swapper.id
    }
  end

  def auctions_create_response
    {
      'id' => Auction.last.id,
      'product_id' => product.id,
      'accepted_bid_id' => nil,
      'state' => 'in_progress',
      'expires_at' => auction.expires_at.strftime('%FT%R:%S.000Z'),
      'swapper_id' => swapper.id
    }
  end
end
