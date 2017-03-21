json.ingredients @ingredients do |ingredient|
	json.(ingredient, :amount, :name)
end