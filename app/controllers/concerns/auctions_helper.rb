# frozen_string_literal: true

module AuctionsHelper
  extend ActiveSupport::Concern
 
  private

  def find_swapper_auction
    @auction ||= auctions&.find_by(id: params[:id])
    head :not_found unless @auction
  end

  def find_swapper_auctions
    @auctions ||= auctions&.to_a || []
  end

  def find_auction
    @auction ||= Auction.find_by(id: params[:id])
    head :not_found unless @auction
  end

  def find_auctions
    @auctions = Auction.all
    @auctions = swapper_id_scope(@auctions)
    @auctions = state_scope(@auctions)
    @auctions = @auctions.to_a
  end

  def swapper_id_scope(scope)
    (swapper_id = params[:swapper_id].presence) ? scope.by_swapper(swapper_id) : scope
  end

  def state_scope(scope)
    (state = params[:state].presence) ? scope.by_state(state) : scope
  end

  def present_auction(object, status)
    present(object, status: status, serializer: 'Serializer::Auction')
  end

  def auction_params
    params.require(:auction).permit(
      :product_id,
      :state,
      :accepted_bid_id,
      :expires_at,
      :swapper_id
    )
  end
end
