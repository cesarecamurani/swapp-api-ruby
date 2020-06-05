class AddSwapperIdToProductsTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :swapper, index: true, type: :uuid
    add_foreign_key :products, :swappers
  end
end
