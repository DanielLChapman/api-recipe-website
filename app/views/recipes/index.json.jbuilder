json.recipes @recipe do |recipes|
	json.(recipes, :id, :title, :description, :meal, :picture, :url)
end