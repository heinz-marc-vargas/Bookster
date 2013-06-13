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

	$("input#branch_address")
	 .required()
	 .keyup(function()
	 {
		keyupcb($(this).validate(),"#branch_address_error");
	 })
	 .blur(function()
	 {
		keyupcb($(this).validate(),"#branch_address_error");
	 });
	 
	 $("input#branch_branch_logo")
   .required()
   .keyup(function()
   {
    keyupcb($(this).validate(),"#branch_branch_logo_error");
   })
   .blur(function()
   {
    keyupcb($(this).validate(),"#branch_branch_logo_error");
   });

	var ctable = function(name)
	{		
		switch (name) {
			case "branch[address]":
				return "#branch_address_error"
				break;
			case "branch[branch_logo]":
				return "#branch_branch_logo_error"
				break;
			default:
				return "";
				break;
		}
	}	
	
	var form = {
		disable : function(){
			$("#add_branch_submit")
			.css("background-image","-moz-linear-gradient(center top , #eee 5%, #eee 100%)")
			.attr("disabled","disabled");
		},
		enable : function(){
			$("#add_branch_submit")
			.css("background-image","-moz-linear-gradient(center top , #80B5EA 5%, #80B5EA 100%)")
			.removeAttr("disabled");	
		}
	}
	
	var submit = $("form[id=new_branch_form]")
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
			var company_id = $("#branch_company").val();
			var address = $("input#branch_address").val();
			var branch_logo = $("input#branch_branch_logo").val();
			var days_am_start_end_pm_start_end = [];
      var index = 0;
      
      $("input[name=day]").each(function() {
        if ($(this).attr("checked")) {
					var day_id = $(this).attr("id").split('_')[1];
          days_am_start_end_pm_start_end[index] = day_id;
					days_am_start_end_pm_start_end[index + 1] = $("#operating_hours_am_start_time_" + day_id).val();
					days_am_start_end_pm_start_end[index + 2] = $("#operating_hours_am_end_time_" + day_id).val();
					days_am_start_end_pm_start_end[index + 3] = $("#operating_hours_pm_start_time_" + day_id).val();
					days_am_start_end_pm_start_end[index + 4] = $("#operating_hours_pm_end_time_" + day_id).val();
          index += 5;
        }
        });
      									
			var param = {
				"authenticity_token" : token,
				"utf8" : utf8,
				"branch[company_id]" : company_id,
				"branch[address]" : address,
				"branch[branch_logo]" : branch_logo,
				"days_hours" : days_am_start_end_pm_start_end
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
				  	$("#branch_" + key + "_error").addClass("validate_msg").removeClass("ok_msg").html(json[key][0]);
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
