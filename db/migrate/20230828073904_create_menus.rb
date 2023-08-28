class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.string :restaurant_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
