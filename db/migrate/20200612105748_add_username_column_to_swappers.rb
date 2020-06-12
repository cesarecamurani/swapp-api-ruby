class AddUsernameColumnToSwappers < ActiveRecord::Migration[6.0]
  def change
    add_column :swappers, :username, :string
  end
end
