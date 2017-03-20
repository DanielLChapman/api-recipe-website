class Step < ApplicationRecord
	validates :instruction, presence: true
	validates :order, numericality: { greater_than_or_equal_to: 1 }, presence: true
	
	belongs_to :recipe

	
	def self.search(params = {})
		if params[:recipe_id].present?
			steps = Recipe.find(params[:recipe_id]).steps
			steps = steps.filter_by_instruction(params[:instruction]) if params[:instruction]
			steps
		end
	end
	
	scope :filter_by_instruction, lambda { |keyword| 
		where("lower(instruction) LIKE ?", "%#{keyword.downcase}%" )
		}
end
