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

//opening the actual recipe.
var viewRecipe = function(recipe_id) {
	$('.recipe-container').show();
	menuChange();
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
	}
	else {
		searchBool = !searchBool;
		$('.search-open').show();
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
						$('.'+tempArr[x][3].toLowerCase()+'-recipes').append("<section class='recipe-info'recipe-id='"+tempArr[x][0]+"'><h6>"+tempArr[x][1]+"</h6></section>");
					}
				});
			}
		});
}