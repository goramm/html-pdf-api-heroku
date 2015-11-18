$(function(){

	var timer;

	function check(){
		var id = getCookie('file_id');
		$.ajax('/check/'+id).done(function(data){
			if(data.message.status == 'Done'){
				deleteCookie('file_id');
				stopChecking();
				window.location = data.message.url; // redirect to pdf file
			}
		});
	}

	function startChecking(){
		$('.generate_pdf').addClass('ajax btn-danger');
		timer = setInterval(check, 2000);
	}

	function stopChecking(){
		$('.generate_pdf').removeClass('ajax');
		clearInterval(timer);
	}

	function deleteCookie( name ) {
	  document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
	}

	function getCookie(name) {
	  var regexp = new RegExp("(?:^" + name + "|;\s*"+ name + ")=(.*?)(?:;|$)", "g");
	  var result = regexp.exec(document.cookie);
	  return (result === null) ? null : result[1];
	}
	
	// if cookie exists start checking
  if(getCookie('file_id')){
  	startChecking();
  }

  // start checking on click
	$('.generate_pdf').click(function(e){
		e.preventDefault();
		var $this = $(this);

		if($this.hasClass('ajax')){ return; }

		$.ajax('/generate_pdf').done(function(data){
			startChecking();
		});
	});

});
