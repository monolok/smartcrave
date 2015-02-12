class AddImagesAttributesToFoods < ActiveRecord::Migration
  def change
  	add_column :images, :data, :binary
  	add_column :images, :filename, :string
  	add_column :images, :mime_type, :string 
  end
end
