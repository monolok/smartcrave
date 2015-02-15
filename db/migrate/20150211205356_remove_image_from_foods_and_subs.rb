class RemoveImageFromFoodsAndSubs < ActiveRecord::Migration
  def change
    remove_column :subs, :image_file_name
    remove_column :foods, :image_file_name
    remove_column :subs, :image_content_type
    remove_column :foods, :image_content_type
    remove_column :subs, :image_file_size
    remove_column :foods, :image_file_size
    remove_column :subs, :image_updated_at
    remove_column :foods, :image_updated_at
    #remove_column :subs, :image_id
    #remove_column :foods, :image_id              
  end
end