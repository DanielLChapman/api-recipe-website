json.recipe do
	json.(@recipe, :id, :title, :description, :meal, :picture)
	json.steps do 
		json.array!(@steps, :instruction, :order)
	end
end