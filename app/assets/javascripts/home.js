$(function(){
  //TODO: kod učitavanja stranice provjeriti dal ima cookie i pokrenuti check
  //TODO: kada završi generiranje pdf-a obrisati cookie
  
 	var timer;

 	function start_checking(){
 		timer = setInterval(check, 3000);
  	$('.generate_pdf').addClass('ajax');
 	}

 	

  if(getCookie('file_id')){
  	start_checking();
  }


	$('.generate_pdf').click(function(e){
		e.preventDefault();
		var $this = $(this);

		if($this.hasClass('ajax')){return;}



		$.ajax('/generate_pdf').done(function(data){
			start_checking();
			console.log(data);
		});
	});

	function check(){
		var id = getCookie('file_id');
		$.ajax('/check/'+id).done(function(data){
			console.log(data);
			if(data.message == 'Done'){
				deleteCookie('file_id');
				$('.generate_pdf').removeClass('ajax');
				clearInterval(timer);
			}
		});
	}
});

	function deleteCookie( name ) {
	  document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
	}

	function getCookie(name) {
	  var regexp = new RegExp("(?:^" + name + "|;\s*"+ name + ")=(.*?)(?:;|$)", "g");
	  var result = regexp.exec(document.cookie);
	  return (result === null) ? null : result[1];
	}
