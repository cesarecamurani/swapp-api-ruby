class AddSwappersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :swappers, id: :uuid do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :date_of_birth
      t.string :phone_number
      t.string :city
      t.string :country
 
      t.timestamps
    end
  end
end
