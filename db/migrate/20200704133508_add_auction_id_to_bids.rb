class AddAuctionIdToBids < ActiveRecord::Migration[6.0]
  def change
    add_reference :bids, :auction, index: true, type: :uuid
    add_foreign_key :bids, :auctions
  end
end
