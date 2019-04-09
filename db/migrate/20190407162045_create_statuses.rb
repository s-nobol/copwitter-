class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.string :address
      t.string :barthday
      t.string :link

      t.timestamps
    end
  end
end
