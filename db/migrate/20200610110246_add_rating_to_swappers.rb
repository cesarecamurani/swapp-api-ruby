class AddRatingToSwappers < ActiveRecord::Migration[6.0]
  def change
    add_column :swappers, :rating, :string
  end
end
