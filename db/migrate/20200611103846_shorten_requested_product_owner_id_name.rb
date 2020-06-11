class ShortenRequestedProductOwnerIdName < ActiveRecord::Migration[6.0]
  def change
    rename_column :swapp_requests, 
                  :requested_product_owner_id, 
                  :req_product_owner_id
  end
end
