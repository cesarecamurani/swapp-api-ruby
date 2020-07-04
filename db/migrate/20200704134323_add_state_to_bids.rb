class AddStateToBids < ActiveRecord::Migration[6.0]
  def change
    add_column :bids, :state, :integer
  end
end
