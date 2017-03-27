// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//Global recipe list
var globalRecipes = [];

//capitalization
String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1).toLowerCase();
}

var searchResults = [];

var jsonCallSearch = function(searchTerm, meal, mealBool) {
	var urlToUse = ''
	if (mealBool) {
		urlToUse = '/recipes?keyword_title='+searchTerm+'&meal='+meal.toLowerCase().capitalizeFirstLetter()+'&format=json'
	}
	else {
		urlToUse = '/recipes?keyword_title='+searchTerm+'&format=json'
	}
	$('.search-open-results').empty();
	$.ajax({ 
		type: 'GET', 
		url: urlToUse, 
		data: { get_param: 'value' }, 
		dataType: 'json',
		success: function (data) { 
			$.each(data, function(index, element) {
				var tempArr = recipeParse(element);
				var tempBool = false;
				for (var q = 0; q < tempArr.length; q++) {
					for (var y = 0; y < searchResults.length; y++) {
						if (searchResults[y][0] == tempArr[q][0]) {
							tempBool = true;
						}
					}
					if (!tempBool) {
						searchResults.push(tempArr[q]);
					}
				}
			});
			for (var p = 0; p < searchResults.length; p++) {
				$('.search-open-results').append("<section class='recipe-info' recipe-id='"+searchResults[p][0]+"' onclick='viewRecipeFromSearch("+p+")'><h6>"+searchResults[p][1]+"</h6></section>");
			}
		}
	});
}

//Regex provided by http://stackoverflow.com/questions/19156148/i-want-to-remove-double-quotes-from-a-string
//And http://stackoverflow.com/questions/16261635/javascript-split-string-by-space-but-ignore-space-in-quotes-notice-not-to-spli
var search = function(text) {
	var searchText = text;
	var searchArr = searchText.match(/(?:[^\s"]+|"[^"]*")+/g) 
	var mealArray = ["Breakfast",  "Lunch", "Dessert", "Snack Dinner"];
	var searchMeal = false;
	var mealToSearch = "";
	for (var x = 0; x < searchArr.length; x++) {
		if (mealArray.indexOf(searchArr[x].toLowerCase().capitalizeFirstLetter()) != -1) {
			searchMeal = true;
			mealToSearch = searchArr[x].toLowerCase().capitalizeFirstLetter();
			if (searchArr.length > 1) {
				searchArr.splice(x, 1);
				x--;
			}
		}
	}
	//for (var x = 0; x < searchArr.length; x++) {
		
	jsonCallSearch(searchArr.join(' '), mealToSearch, searchMeal);
	//}
	
}
$(document).keypress(function(e) {
	if ($(".pages.admin")[0]){
	} else {
    	var key = e.which;
		if (key == 13) // the enter key code
		{
			searchResults = [];
			if ($('.search-field').val().length > 0) {
				search($('.search-field').val()); 
			}
		}
	}
});
//opening the actual recipe.
var viewRecipeFromSearch = function(recipe_id) {
	var forFailToCall = false;
	for (var x = 0; x < globalRecipes.length; x++) {
		if (globalRecipes[x][1] == searchResults[recipe_id][1]) {
			forFailToCall = true;
			viewRecipe(x);
		}
	}
	if (!forFailToCall) {
		viewRecipe(searchResults[recipe_id][0]);
	}
}
var viewRecipe = function(recipe_id) {
	$('.recipe-container').show();
	if (menuBool) {
		menuChange();
	}
	if (searchBool) {
		searchChange();
	}
	
	//check if we have grabbed the recipes yet
	var currentRecipe = [];
	if (globalRecipes.length > 0) {
		currentRecipe = globalRecipes[recipe_id];
	}
	else {
		$.ajax({ 
			type: 'GET', 
			//This should be the param[:recipe_id] for individual calls and not the tempArr one, will have to test
			url: '/recipes/'+recipe_id+'.json', 
			data: { get_param: 'value' }, 
			dataType: 'json',
			success: function (data) { 
				$.each(data, function(index, element) {
					var tempArr = recipeParse(element).reverse();
					currentRecipe = tempArr;
				});
			}
		});
	}
	$.ajax({ 
		type: 'GET', 
		url: '/recipes/'+currentRecipe[0]+'/ingredients.json', 
		data: { get_param: 'value' }, 
		dataType: 'json',
		success: function (data) { 
			$.each(data, function(index, element) {
				var tempArr = ingredientParse(element);
				for (var x = 0; x < tempArr.length; x++) {
					$('.ind-recipe-ingredients').append('<li><h4>'+tempArr[x][0] + " | " + tempArr[x][1] +'</h4></li>');
				}
			});
		}
	});
	$.ajax({ 
		type: 'GET', 
		url: '/recipes/'+currentRecipe[0]+'/steps.json', 
		data: { get_param: 'value' }, 
		dataType: 'json',
		success: function (data) { 
			$.each(data, function(index, element) {
				var tempArr = stepParse(element);
				for (var x = 0; x < tempArr.length; x++) {
					$('.ind-recipe-steps').append('<li><h4>'+tempArr[x][0] + ". " + tempArr[x][1] +'</h4></li>');
				}
			});
		}
	});
	$('.ind-recipe-title').text(currentRecipe[1]);
	$('.ind-recipe-description').text(currentRecipe[2]);
	$('.ind-recipe-image').attr("src", currentRecipe[4]);
}

//menu opening and closing
var menuBool = false;
var menuChange = function() {
	if (menuBool) {
		menuBool = !menuBool;
		$('.menu-open').hide();
	}
	else {
		menuBool = !menuBool;
		$('.menu-open').show();
	}
}

//search opening and closing
var searchBool = false;
var searchChange = function() {
	if (searchBool) {
		searchBool = !searchBool;
		$('.search-open').hide();
		$('.search-open-results').hide();
	}
	else {
		searchBool = !searchBool;
		$('.search-open').show();
		$('.search-open-results').show();
	}
}
//Open recipe-title boxes
var lastSelected = "";
var openRecipes = function(secClass) {
	$('.recipe-titles').hide();
	if (lastSelected != secClass) { 
		$('.'+secClass).show();
	}
	lastSelected = secClass;
}

//Parsing
var recipeParse = function(data) {
	var results = [];
	for (var x = 0; x < data.length; x++) {
		var tempArr = [];
		tempArr.push(data[x].id);
		tempArr.push(data[x].title);
		tempArr.push(data[x].description);
		tempArr.push(data[x].meal);
		tempArr.push(data[x].picture);
		results.push(tempArr);
	}
	
	return results;
}
var stepParse = function(data) {
	var results = [];
	for (var x = 0; x < data.length; x++) {
		var tempArr = [];
		tempArr.push(data[x].order);
		tempArr.push(data[x].instruction);
		results.push(tempArr);
	}
	
	return results;
}

var ingredientParse = function(data) {
	var results = [];
	for (var x = 0; x < data.length; x++) {
		var tempArr = [];
		tempArr.push(data[x].amount);
		tempArr.push(data[x].name);
		results.push(tempArr);
	}
	
	return results;
}

var populateGA = function() {
	$.ajax({ 
			type: 'GET', 
			url: '/recipes.json', 
			data: { get_param: 'value' }, 
			dataType: 'json',
			success: function (data) { 
				$.each(data, function(index, element) {
					var tempArr = recipeParse(element).reverse();
					globalRecipes = tempArr;
					for (var x = 0; x < tempArr.length; x++) {
						$('.all-meals-recipes').append("<section class='recipe-info' recipe-id='"+tempArr[x][0]+"' onclick='viewRecipe("+x+")'><h6>"+tempArr[x][1]+"</h6></section>");
						$('.'+tempArr[x][3].toLowerCase()+'-recipes').append("<section class='recipe-info'recipe-id='"+tempArr[x][0]+"' onclick='viewRecipe("+x+")'><h6>"+tempArr[x][1]+"</h6></section>");
					}
				});
			}
		});
}

$(document).on('submit', '.edit-recipe-form', function(e) {
	var valuesToSubmite = $(this).serialize();
	e.preventDefault();
	$.ajax({
		type: "PATCH",
		url: $(this).attr('action'),
		beforeSend: function (xhr) {
			xhr.setRequestHeader('Authorization', auth_token);
		},
		data: valuesToSubmite,
		dataType: "JSON",
		success: function (data) { 
        	console.log("success", data);
		}
    });
    return false;
});
