class ChangeAuctionsStatusToState < ActiveRecord::Migration[6.0]
  def change
    rename_column :auctions, :status, :state
  end
end
