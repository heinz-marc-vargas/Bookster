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

	$("input#service_name")
	 .required()
	 .keyup(function()
	 {
		keyupcb($(this).validate(),"#service_name_error");
	 })
	 .blur(function()
	 {
		keyupcb($(this).validate(),"#service_name_error");
	 });

	$("input#service_description")
	 .required()
	 .keyup(function()
	 {
		keyupcb($(this).validate(),"#service_description_error");
	 })
	 .blur(function()
	 {
		keyupcb($(this).validate(),"#service_description_error");
	 });

	var ctable = function(name)
	{
		switch (name) {
			case "service[name]":
				return "#service_name_error"
				break;
			case "service[description]":
				return "#service_description_error"
				break;
			case "service[duration]":
				return "#service_duration_error"
				break;
			default:
				return "";
				break;
		}
	}	
	
	var form = {
		disable : function(){
			$("#add_service_submit")
			.css("background-image","-moz-linear-gradient(center top , #eee 5%, #eee 100%)")
			.attr("disabled","disabled");
		},
		enable : function(){
			$("#add_service_submit")
			.css("background-image","-moz-linear-gradient(center top , #80B5EA 5%, #80B5EA 100%)")
			.removeAttr("disabled");	
		}
	}
	
	var submit = $("form[id=new_service_form]")
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
			var name = $("input#service_name").val();
			var description  = $("input#service_description").val();
			var duration = $("input#service_duration").val();
			var charge = $("input#service_charge").val();

									
			var param = {
				"authenticity_token" : token,
				"utf8" : utf8,
				"service[name]" : name,
				"service[description]" : description,
				"service[duration]" : duration,
				"service[charge]" : charge,
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
				  	$("#service_" + key + "_error").addClass("validate_msg").removeClass("ok_msg").html(json[key][0]);
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
