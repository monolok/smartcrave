class AddCounterToSubs < ActiveRecord::Migration
  def change
    add_column :subs, :counter, :integer
  end
end
