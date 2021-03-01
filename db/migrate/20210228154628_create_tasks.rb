class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    ActiveRecord::Migration[6.1].create_table :tasks do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.string :status
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
