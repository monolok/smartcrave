class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
