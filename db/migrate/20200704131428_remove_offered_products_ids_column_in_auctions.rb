class RemoveOfferedProductsIdsColumnInAuctions < ActiveRecord::Migration[6.0]
  def change
    remove_column :auctions, :offered_products_ids
  end
end
