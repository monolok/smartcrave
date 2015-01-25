class AddCounterToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :counter, :integer
  end
end
