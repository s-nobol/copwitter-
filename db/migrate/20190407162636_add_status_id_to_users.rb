class AddStatusIdToUsers < ActiveRecord::Migration[5.2]
  def change
    # add_column :status ,:user_id , :string
    add_column :statuses, :user_id, :string
  end
end
