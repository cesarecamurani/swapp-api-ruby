# frozen_string_literal: true

module BidsHelper
  extend ActiveSupport::Concern
 
  private

  def find_bid
    @bid ||= bids&.find_by(id: params[:id])
    head :not_found unless @bid
  end

  def find_bids
    @bids ||= bids&.to_a || []
  end

  def present_bid(object, status)
    present(object, status: status, serializer: 'Serializer::Bid')
  end

  def bid_params
    params.require(:bid).permit(
      :product_id,
      :state,
      :auction_id
    )
  end
end
