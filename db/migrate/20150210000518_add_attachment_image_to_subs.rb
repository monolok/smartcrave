class AddAttachmentImageToSubs < ActiveRecord::Migration
  def self.up
    change_table :subs do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :subs, :image
  end
end
