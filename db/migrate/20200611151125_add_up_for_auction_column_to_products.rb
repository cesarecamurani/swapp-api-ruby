class AddUpForAuctionColumnToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products,
               :up_for_auction,
               :boolean,
               default: false
  end
end
