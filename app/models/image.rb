class Image < ActiveRecord::Base
	belongs_to :img_duty, polymorphic: true
end
