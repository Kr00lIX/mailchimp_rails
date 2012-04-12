class AddSubscriptionStateAndSubscriptionErrorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_state, :string
    add_column :users, :subscription_last_error, :string

    add_index :users, :subscription_state
  end
end
