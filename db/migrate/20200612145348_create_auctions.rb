class CreateAuctions < ActiveRecord::Migration[6.0]
  def change
    create_table :auctions, id: :uuid do |t|
      t.uuid :product_id
      t.string :status
      t.string :offered_products_ids, array: true, default: []
      t.string :accepted_product_id
      t.timestamp :expires_at
      t.timestamps
    end

    add_reference :auctions, :swapper, index: true, type: :uuid
    add_foreign_key :auctions, :swappers
  end
end
