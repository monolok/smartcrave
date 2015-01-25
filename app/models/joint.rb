class Joint < ActiveRecord::Base
	belongs_to :food
	belongs_to :sub
end
