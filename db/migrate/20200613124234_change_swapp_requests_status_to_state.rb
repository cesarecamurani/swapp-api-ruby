class ChangeSwappRequestsStatusToState < ActiveRecord::Migration[6.0]
  def change
    rename_column :swapp_requests, :status, :state
  end
end
