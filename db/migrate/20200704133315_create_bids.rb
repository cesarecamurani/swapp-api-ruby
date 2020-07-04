class CreateBids < ActiveRecord::Migration[6.0]
  def change
    create_table :bids, id: :uuid do |t|
      t.uuid :product_id
      t.timestamps
    end
  end
end
