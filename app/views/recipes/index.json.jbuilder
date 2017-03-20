json.recipes @recipe do |recipes|
	json.(recipes, :id, :title, :description, :meal, :picture)
	json.steps do 
		json.array!(@steps, :instruction, :order)
	end
end