class AddDepartmentColumnToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :department, :string
  end
end
