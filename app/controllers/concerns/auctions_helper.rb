# frozen_string_literal: true

module AuctionsHelper
  extend ActiveSupport::Concern
 
  private

  def find_auction_for_swapper
    @auction ||= auctions&.find_by(id: params[:id])
    head :not_found unless @auction
  end

  def find_auctions_for_swapper
    @products ||= auctions&.to_a || []
  end

  def find_auction
    @auction ||= Auction.find_by(id: params[:id])
    head :not_found unless @auction
  end

  def find_auctions
    @auctions = Auction.all
    @auctions = swapper_id_scope(@auctions)
    @auctions = status_scope(@auctions)
    @auctions = @auctions.to_a
  end

  def swapper_id_scope(scope)
    (swapper_id = params[:swapper_id].presence) ? scope.by_swapper(swapper_id) : scope
  end

  def state_scope(scope)
    (state = params[:state].presence) ? scope.by_state(state) : scope
  end

  def auctions
    current_swapper&.auctions
  end

  def present_auction(object, status)
    present(object, status: status, serializer: 'Serializer::Auction')
  end

  def auction_params
    params.require(:auction).permit(
      :product_id,
      :state,
      :accepted_product_id,
      :expires_at,
      :swapper_id,
      offered_products_ids: []
    )
  end
end
