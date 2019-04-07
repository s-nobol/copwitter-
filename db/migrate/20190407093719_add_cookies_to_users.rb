class AddCookiesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cookies_digest, :string
  end
end
