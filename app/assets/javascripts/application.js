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