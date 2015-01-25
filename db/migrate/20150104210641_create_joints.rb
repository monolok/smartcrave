class CreateJoints < ActiveRecord::Migration
  def change
    create_table :joints do |t|
      t.integer :food_id
      t.integer :sub_id

      t.timestamps null: false
    end
  end
end
