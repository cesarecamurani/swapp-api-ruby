class ChangeAuctionsStateTypeToInteger < ActiveRecord::Migration[6.0]
  def change
    execute 'ALTER TABLE auctions ALTER COLUMN state TYPE int2 USING (state::int2);'
  end
end
