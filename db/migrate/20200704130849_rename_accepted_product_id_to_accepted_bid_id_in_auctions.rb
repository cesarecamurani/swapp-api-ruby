class RenameAcceptedProductIdToAcceptedBidIdInAuctions < ActiveRecord::Migration[6.0]
  def change
    rename_column :auctions, :accepted_product_id, :accepted_bid_id
  end
end
