class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :phone
      t.string :email
      t.float :weight
      t.float :length
      t.float :width
      t.float :height
      t.string :from
      t.string :to
      t.float :distance
      t.float :price

      t.timestamps
    end
  end
end
