class CreateProductsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :type
      t.string :title
      t.string :description
 
      t.timestamps
    end
  end
end
