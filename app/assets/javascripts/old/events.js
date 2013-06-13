var add = (function(jQuery){
	
	VJ.init({
		success_msg_format : "Valid input."
	});
	
	var targeturl;
	var redirectUrl;
	
	var keyupcb = function(results,id)
	{	
		if(results.status == VJ.FAIL)
		{
			$(id).addClass("validate_msg");
			$(id).removeClass("ok_msg");
			$(id).html(results.error.message);
		}
		else 
		{
			$(id).removeClass("validate_msg");
			$(id).addClass("ok_msg");
			$(id).html(results.message);	
		}
	}

	$("input#event_title")
	 .required()
	 .keyup(function()
	 {
		keyupcb($(this).validate(),"#event_title_error");
	 })
	 .blur(function()
	 {
		keyupcb($(this).validate(),"#event_title_error");
	 });

	$("input#event_description")
	 .required()
	 .keyup(function()
	 {
		keyupcb($(this).validate(),"#event_description_error");
	 })
	 .blur(function()
	 {
		keyupcb($(this).validate(),"#event_description_error");
	 });

	var ctable = function(name)
	{
		switch (name) {
			case "event[name]":
				return "#event_name_error"
				break;
			case "event[description]":
				return "#event_description_error"
				break;
			case "event[starts_at]":
				return "#event_starts_at_error"
				break;
			case "event[starts_at]":
				return "#event_end_at_error"
				break;
			default:
				return "";
				break;
		}
	}	
	
	var form = {
		disable : function(){
			$("#add_event_submit")
			.css("background-image","-moz-linear-gradient(center top , #eee 5%, #eee 100%)")
			.attr("disabled","disabled");
		},
		enable : function(){
			$("#add_event_submit")
			.css("background-image","-moz-linear-gradient(center top , #80B5EA 5%, #80B5EA 100%)")
			.removeAttr("disabled");	
		}
	}
	
	var submit = $("form[id=new_event_form]")
		.submit(function(){
			
			var results = $.validate();
			
			if($.hasErrors())
			{
				var names = results.names;
				for(var id in names)
				{
					var error = names[id];
					keyupcb(error,ctable(id));
				}
				
				return false;
			}
		
			var token = $("input[name=authenticity_token]").val();
			var utf8 = $("input[name=utf8]").val();
			var name = $("input#event_title").val();
			var description  = $("input#event_description").val();
			var duration = $("input#event_starts_at").val();
			var charge = $("input#event_ends_at").val();

									
			var param = {
				"authenticity_token" : token,
				"utf8" : utf8,
				"event[title]" : title,
				"event[staff_id]" : staff_id,
				"event[service_id]" : service_id,				
				"event[starts_at]" : starts_at,
				"event[ends_at]" : ends_at,
			};
						
			$.ajax({
			   type: "POST", url: targeturl, data: param, dataType : "json",
			   success: function(json){
				  location.href = redirectUrl;
			   },
			   error : function(xhr,status,error)
			   {	   	
				  var json = $.parseJSON(xhr.responseText);
				  for (var key in json) 
				  {		  
				  	$("#event_" + key + "_error").addClass("validate_msg").removeClass("ok_msg").html(json[key][0]);
				  }
			   },
			   beforeSend : function(){
			   	  form.disable();
			   },
			   complete : function(){
			   	  form.enable();
			   }
 			});
			return false;
	});

	return {
		setTargetUrl : function(url){
			targeturl = url;
			return this;
		},
		setRedirectUrl : function(url){
			redirectUrl = url;
			return this;
		}
	};
	
})(jQuery);
