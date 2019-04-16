class AddImageToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :background_image, :string
    add_column :users, :message, :string
    add_column :users, :address, :string
    add_column :users, :link, :string
    add_column :users, :barthday, :string
  end
end
