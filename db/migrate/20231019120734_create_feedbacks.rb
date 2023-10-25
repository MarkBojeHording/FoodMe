class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.text :comment
      t.date :feedback_date

      t.timestamps
    end
  end
end
