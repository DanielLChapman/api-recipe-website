class Step < ApplicationRecord
	validates :instruction, presence: true
	validates :order, numericality: { greater_than_or_equal_to: 1 }, presence: true
	
	belongs_to :recipe

end
