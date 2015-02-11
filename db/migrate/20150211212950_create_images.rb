class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :img_duty_id
      t.string :img_duty_type

      t.timestamps null: false
    end
  end
end
