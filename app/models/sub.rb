class Sub < ActiveRecord::Base
	#searchkick
	has_many :joints
	has_many :foods, :through => :joints
	accepts_nested_attributes_for :foods, reject_if: :all_blank, allow_destroy: true

	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
