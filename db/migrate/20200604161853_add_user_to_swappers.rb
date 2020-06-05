class AddUserToSwappers < ActiveRecord::Migration[6.0]
  def change
    add_reference :swappers, :user, index: true, type: :uuid
    add_foreign_key :swappers, :users
  end
end
