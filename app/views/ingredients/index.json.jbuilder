json.ingredients @ingredients do |ingredient|
	json.(ingredient, :id, :amount, :name)
end