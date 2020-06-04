class AddAddressToSwappersTable < ActiveRecord::Migration[6.0]
  def change
    add_column :swappers, :address, :string
  end
end
