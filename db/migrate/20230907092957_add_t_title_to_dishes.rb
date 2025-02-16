class AddTTitleToDishes < ActiveRecord::Migration[7.0]
  def change
    add_column :dishes, :t_title, :string
  end
end
