class CreateSwappRequestsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :swapp_requests, id: :uuid do |t|
      t.string :status
      t.uuid :offered_product_id
      t.uuid :requested_product_id
      t.uuid :requested_product_owner_id
 
      t.timestamps
    end

    add_reference :swapp_requests, :swapper, index: true, type: :uuid
    add_foreign_key :swapp_requests, :swappers
  end
end
