class Food < ActiveRecord::Base
	#searchkick
	has_many :joints
	has_many :subs, :through => :joints
  has_one :image, as: :img_duty
	accepts_nested_attributes_for :subs, reject_if: :all_blank, allow_destroy: true
  #accepts_nested_attributes_for :image, reject_if: :all_blank, allow_destroy: true
  # has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  # validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("name like ?", "%#{query}%") 
  end

end
