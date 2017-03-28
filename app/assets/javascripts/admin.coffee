userArray = [];
root = exports ? this
root.sortAdminData = () ->
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
			(($) ->
				$('.recipe-table-body').empty();
			) jQuery
			for i in [0...data.recipes.length]
				(($) ->
					$('.recipe-table-body').append("<tr><td>"+data.recipes[i].id+"</td><td>"+data.recipes[i].title+"</td><td><a data-remote='true' href='/recipes/"+data.recipes[i].id+"/edit'>Edit</a></td><td><a class='recipe-delete' data-confirm='You Sure?' rel='nofollow' data-remote='true' data-method='delete' href='/recipes/"+data.recipes[i].id+"/' rid='"+data.recipes[i].id+"'>Delete</a></td><td><span class='edit-step-button'  rid='"+data.recipes[i].id+"'>Edit Steps</span></td><td><span class='edit-ingredient-button' rid='"+data.recipes[i].id+"'>Edit Ingredients</span></td></tr>");
				) jQuery
	
$(".pages.admin").ready ->
  $(".login_form").on("ajax:success", (e, data, status, xhr) ->
    userArray = [data.id, data.auth_token, data.email]; sortAdminData( data );
  ).on("ajax:error", (e, xhr, status, error) ->
    console.log( error);
  )