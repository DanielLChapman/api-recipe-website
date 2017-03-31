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
var auth_token = "";
var user_id = "";

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
var ajaxCall = function(type, url, dataH, dataType, auth) {
	return new Promise(function(resolve, reject) {
		if (auth) {
			setAuthUser();
			$.ajax({
				type: type,
				url: url,
				beforeSend: function (xhr) {
					xhr.setRequestHeader('Authorization', auth_token);
				},
				data: dataH,
				dataType: dataType,
				processData: false,
    			contentType: false,
				success: function (data) { 
					resolve(data);
				},
				error: function (jqxhr, textStatus, errorThrown) {
					errorParse(jqxhr.responseText);
				}
			});
		}
		else {
			$.ajax({ 
				type: type, 
				//This should be the param[:recipe_id] for individual calls and not the tempArr one, will have to test
				url: url, 
				data: dataH, 
				dataType: dataType,
				processData: false,
    			contentType: false,
				success: function (data) { 
					resolve(data);
				},
				error: function (jqxhr,textStatus, errorThrown) {
					errorParse(jqxhr.responseText);
            	}
			});
		}
	});
};

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
		var data = ajaxCall('GET','/recipes/'+recipe_id+'.json',{ get_param: 'value' },'json',false);
		$.each(data, function(index, element) {
			var tempArr = recipeParse(element).reverse();
			currentRecipe = tempArr;
		});
	}
	ajaxCall('GET', '/recipes/'+currentRecipe[0]+'/ingredients.json',{ get_param: 'value' },'json',false).then(function(dataIng) {
		$.each(dataIng, function(index, element) {
			$('.ind-recipe-ingredients').empty();
			var tempArr = ingredientParse(element);
			for (var x = 0; x < tempArr.length; x++) {
				$('.ind-recipe-ingredients').append('<li><h4>'+tempArr[x][0] + " | " + tempArr[x][1] +'</h4></li>');
			}
		});
	});
	ajaxCall('GET', '/recipes/'+currentRecipe[0]+'/steps.json',{ get_param: 'value' },'json',false).then(function(dataStep) {
		$('.ind-recipe-steps').empty();
		$.each(dataStep, function(index, element) {
			var tempArr = stepParse(element);
			for (var x = 0; x < tempArr.length; x++) {
				$('.ind-recipe-steps').append('<li><h4>'+tempArr[x][0] + ". " + tempArr[x][1] +'</h4></li>');
			}
		});
	});
	$('.ind-recipe-title').text(currentRecipe[1]);
	$('.ind-recipe-description').text(currentRecipe[2]);
	$('.ind-recipe-url').html("Source: <a href='" + currentRecipe[5] + "'>Here</a>" );
	
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
		tempArr.push(data[x].picture.picture.url);
		console.log(data[x].picture.picture.url);
		tempArr.push(data[x].url);
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
	ajaxCall('GET', '/recipes.json',{ get_param: 'value' },'json',false).then(function(data) {
		
		$.each(data, function(index, element) {
			var tempArr = recipeParse(element).reverse();
			globalRecipes = tempArr;
			for (var x = 0; x < tempArr.length; x++) {
				$('.all-meals-recipes').append("<section class='recipe-info' recipe-id='"+tempArr[x][0]+"' onclick='viewRecipe("+x+")'><h6>"+tempArr[x][1]+"</h6></section>");
				$('.'+tempArr[x][3].toLowerCase()+'-recipes').append("<section class='recipe-info'recipe-id='"+tempArr[x][0]+"' onclick='viewRecipe("+x+")'><h6>"+tempArr[x][1]+"</h6></section>");
			}
		});
		
	});
}



//ADMIN PAGE
var errorParse = function(reason) {
	$('.error-box ul').empty();
	var reason = $.parseJSON(reason)
	$('.error-box').fadeIn(250);
	setTimeout(function() {
		$('.error-box').fadeOut(250);
	}, 3250);
	for (x in reason.errors) {
		switch (x) {
			case "meal":
				for (var x = 0; x < reason.errors.meal.length; x++ ) { $('.error-box ul').append("<li><h4>Meal: "+reason.errors.meal[x]+"</h4></li>"); }
				break;
			case "title":
				for (var x = 0; x < reason.errors.title.length; x++ ) { $('.error-box ul').append("<li><h4>Title: "+reason.errors.title[x]+"</h4></li>"); }
				break;
			case "image":
				for (var x = 0; x < reason.errors.image.length; x++ ) { $('.error-box ul').append("<li><h4>Image: "+reason.errors.image[x]+"</h4></li>"); }
				break;
			case "description":
				for (var x = 0; x < reason.errors.description.length; x++ ) { $('.error-box ul').append("<li><h4>Description: "+reason.errors.description[x]+"</h4></li>"); }
				break;
			
			case "order":
				for (var x = 0; x < reason.errors.order.length; x++ ) { $('.error-box ul').append("<li><h4>Order: "+reason.errors.order[x]+"</h4></li>"); }
				break;
			case "instruction":
				for (var x = 0; x < reason.errors.instruction.length; x++ ) { $('.error-box ul').append("<li><h4>Instruction: "+reason.errors.instruction[x]+"</h4></li>"); }
				break;
				
			case "amount":
				for (var x = 0; x < reason.errors.amount.length; x++ ) { $('.error-box ul').append("<li><h4>Amount: "+reason.errors.amount[x]+"</h4></li>"); }
				break;
			case "name":
				for (var x = 0; x < reason.errors.name.length; x++ ) { $('.error-box ul').append("<li><h4>Name: "+reason.errors.name[x]+"</h4></li>"); }
				break;	
		}
	}
}
var setAuthUser = function() {
	auth_token = $('.container').attr("auth_token");
	user_id = $('.container').attr("user_id");
}
//news
$(document).on('submit', '.new-recipe-form', function(event) {
	setAuthUser();
	var valuesToSubmite = new FormData($(this)[0]);//$(this).serialize();
	event.preventDefault();
	
	ajaxCall('POST', $(this).attr('action'), valuesToSubmite, 'json', true).then(function(data) {
		sortAdminData();
		console.log("success");
	});
	
    return false;
});
$(document).on('submit', '.new-ingredient-form', function(event) {
	setAuthUser();
	var valuesToSubmite = $(this).serialize();
	event.preventDefault();
	var rid = $('.ingredients-new-class a').attr("rid");
	
	ajaxCall('POST', $(this).attr('action'), valuesToSubmite, 'json', true).then(function(data) {
		console.log("success");
		$('.ingredient-table-body').append("<tr class='ingredient-row"+data.id+"'><td>"+data.id+"</td><td class='edit-ingredient-table-td-amount-"+data.id+"'>"+data.amount+"</td><td class='edit-ingredient-table-td-name-"+data.id+"'>"+data.name+"</td><td><a data-remote='true' href='/recipes/"+rid+"/ingredients/"+data.id+"/edit'>Edit</a></td><td><a class='ingredient-delete' data-confirm='You Sure?' rel='nofollow' data-remote='true' data-method='delete' href='#' rid='"+rid+"' sid='"+data.id+"'>Delete</a></td></tr>");
	});
    return false;
});
$(document).on('submit', '.new-step-form', function(event) {
	setAuthUser();
	var valuesToSubmite = $(this).serialize();
	event.preventDefault();
	var rid = $('.steps-new-class a').attr("rid");
	
	ajaxCall('POST', $(this).attr('action'), valuesToSubmite, 'json', true).then(function(data) {
		console.log("success");
		$('.step-table-body').append("<tr class='step-row"+data.id+"'><td>"+data.id+"</td><td class='edit-step-table-td-order-"+data.id+"'>"+data.order+"</td><td class='edit-step-table-td-instruction-"+data.id+"'>"+data.instruction+"</td><td><a data-remote='true' href='/recipes/"+rid+"/steps/"+data.id+"/edit'>Edit</a></td><td><a class='step-delete' data-confirm='You Sure?' rel='nofollow' data-remote='true' data-method='delete' href='#' rid='"+rid+"' sid='"+data.id+"'>Delete</a></td></tr>");
	});
    return false;
});
//edits
$(document).on('submit', '.edit-recipe-form', function(event) {
	setAuthUser();
	var valuesToSubmite = $(this).serialize();
	event.preventDefault();
	
	ajaxCall('PATCH', $(this).attr('action'), valuesToSubmite, 'json', true).then(function(data) {
		sortAdminData();
		console.log("success");
	});
	
    return false;
});

$(document).on('submit', '.edit-step-form', function(event) {
	setAuthUser();
	var valuesToSubmite = $(this).serialize();
	event.preventDefault();
	var rid = $('.steps-new-class a').attr("rid");
	//var url = '/recipes/'+rid+'/steps/'+id;
	//console.log(url);
	
	ajaxCall('PATCH', $(this).attr('action'), valuesToSubmite, 'json', true).then(function(data) {
		console.log("success");
		$('.edit-step-table-td-order-'+data.id).text(data.order);
		$('.edit-step-table-td-instruction-'+data.id).text(data.instruction);
	});

    return false;
});

$(document).on('submit', '.edit-ingredients-form', function(event) {
	setAuthUser();
	var valuesToSubmite = $(this).serialize();
	event.preventDefault();
	
	ajaxCall('PATCH', $(this).attr('action'), valuesToSubmite, 'json', true).then(function(data) {
		console.log("success");
		$('.edit-ingredient-table-td-amount-'+data.id).text(data.amount);
		$('.edit-ingredient-table-td-name-'+data.id).text(data.name);
	});
	
    return false;
});

//delete
$(document).on('click', '.recipe-delete', function(event) {
	event.preventDefault();
	var url = "/recipes/"+$(this).attr('rid');
	setAuthUser();
	
	ajaxCall('DELETE', url, {}, 'json', true).then(function(data) {
		console.log("success");
        sortAdminData();
	});


	return false;
});
$(document).on('click', '.step-delete', function(event) {
	event.preventDefault();
	var sid = $(this).attr('sid');
	var url = "/recipes/"+$(this).attr('rid')+"/steps/"+sid;
	
	setAuthUser();
	
	ajaxCall('DELETE', url, {}, 'json', true).then(function(data) {
		console.log("success");
        $('.step-row'+sid).empty();
	});

	return false;
});
$(document).on('click', '.ingredient-delete', function(event) {
	event.preventDefault();
	var sid = $(this).attr('sid');
	var url = "/recipes/"+$(this).attr('rid')+"/ingredients/"+sid;
	
	setAuthUser();
	
	ajaxCall('DELETE', url, {}, 'json', true).then(function(data) {
		console.log("success");
        $('.ingredient-row'+sid).empty();
	});
	
	return false;
});
//grab all steps for recipe
$(document).on('click', '.edit-step-button', function() {
	var rid = $(this).attr('rid');
	var url = "/recipes/"+$(this).attr('rid')+"/steps";
	$('.steps-new-class').html('Steps <a rel="nofollow" data-remote="true" rid="'+rid+'" href="/recipes/'+rid+'/steps/new"><i class="fa fa-plus-square icon-step-new" aria-hidden="true" "></i></a>');
	$('.ingredients-new-class').html('Ingredients');
	$('.step-table-body').empty();
	ajaxCall('GET', url, {}, 'json', true).then(function(data) {
		for (var i = 0; i < data.steps.length; i++) {
			$('.step-table-body').append("<tr class='step-row"+data.steps[i].id+"'><td>"+data.steps[i].id+"</td><td class='edit-step-table-td-order-"+data.steps[i].id+"'>"+data.steps[i].order+"</td><td class='edit-step-table-td-instruction-"+data.steps[i].id+"'>"+data.steps[i].instruction+"</td><td><a data-remote='true' href='/recipes/"+rid+"/steps/"+data.steps[i].id+"/edit'>Edit</a></td><td><a class='step-delete' data-confirm='You Sure?' rel='nofollow' data-remote='true' data-method='delete' href='#' rid='"+rid+"' sid='"+data.steps[i].id+"'>Delete</a></td></tr>");
		}
	});
	
});
//grab all ingredients for recipes
$(document).on('click', '.edit-ingredient-button', function() {
	var rid = $(this).attr('rid');
	var url = "/recipes/"+$(this).attr('rid')+"/ingredients";
	$('.ingredients-new-class').html('Ingredients <a rel="nofollow" data-remote="true" rid="'+rid+'" href="/recipes/'+rid+'/ingredients/new" ><i class="fa fa-plus-square icon-ingredient-new" aria-hidden="true"></i></a>');
	$('.steps-new-class').html('Steps');
	$('.ingredient-table-body').empty();
	
	
	ajaxCall('GET', url, {}, 'json', true).then(function(data) {
		for (var i = 0; i < data.ingredients.length; i++) {
			$('.ingredient-table-body').append("<tr class='ingredient-row"+data.ingredients[i].id+"'><td>"+data.ingredients[i].id+"</td><td class='edit-ingredient-table-td-amount-"+data.ingredients[i].id+"'>"+data.ingredients[i].amount+"</td><td class='edit-ingredient-table-td-name-"+data.ingredients[i].id+"'>"+data.ingredients[i].name+"</td><td><a data-remote='true' href='/recipes/"+rid+"/ingredients/"+data.ingredients[i].id+"/edit'>Edit</a></td><td><a class='ingredient-delete' data-confirm='You Sure?' rel='nofollow' data-remote='true' data-method='delete' href='#' rid='"+rid+"' sid='"+data.ingredients[i].id+"'>Delete</a></td></tr>");
		}
	});

});