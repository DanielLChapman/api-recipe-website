userArray = [];
sortAdminData = (data) ->
	userArray = [data.id, data.auth_token, data.email];
	(($) ->
		$('.login-box').hide();
		$('.admin-cont').css("filter", "none");
		$('.container').attr("auth_token", userArray[1]);
		$('.container').attr("user_id", userArray[0]);
	) jQuery
	$.ajax '/recipes',
		type: 'GET',
		dataType: 'json',
		error: (jqXHR, textStatus, errorThrown) ->
			console.log(errorThrown);
		success: (data, textStatus, jqXHR) ->
			for i in [0...data.recipes.length]
				(($) ->
					$('.recipe-table-body').append("<tr><td>"+data.recipes[i].id+"</td><td>"+data.recipes[i].title+"</td><td><a data-remote='true' href='/recipes/"+data.recipes[i].id+"/edit'>Edit</a></td></tr>");
				) jQuery
			console.log(data.recipes.length);
	
$(".pages.admin").ready ->
  $(".login_form").on("ajax:success", (e, data, status, xhr) ->
    sortAdminData( data );
  ).on "ajax:error", (e, xhr, status, error) ->
    console.log( error);