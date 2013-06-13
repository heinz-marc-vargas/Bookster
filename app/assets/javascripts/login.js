//= require jquery
//= require jquery_ujs
//= require ./flat/bootstrap.min
//= require ./gebo_admin_1.4/lib/qtip2/jquery.qtip.min
//= require ./flat/plugins/validation/jquery.validate.min
//= require ./flat/plugins/nicescroll/jquery.nicescroll.min
//= require_self


//* detect touch devices 
function is_touch_device() {
  return !!('ontouchstart' in window);
}

$(document).ready(function(){

	//* tooltips
	gebo_tips.init();

  if(!is_touch_device()){
  //* popovers
      gebo_popOver.init();
  }

	//* boxes animation
	form_wrapper = $('.login_box');

	function boxHeight() {
		form_wrapper.animate({ marginTop : ( - ( form_wrapper.height() / 2) - 24) },400);
	};

	if(form_wrapper.find('form:visible').attr("id") == 'reg_form')
	{
    form_wrapper.css({ top : 0, marginTop: 10 });
	}
	else
	{
	  form_wrapper.css({ marginTop : ( - ( form_wrapper.height() / 2) - 24) });
  }

  $('.linkform a,.link_reg a').on('click',function(e){
		var target	= $(this).attr('href'),
			target_height = $(target).actual('height');
		$(form_wrapper).css({
			'height'		: form_wrapper.height()
	});

	$(form_wrapper.find('form:visible')).fadeOut(400,function(){
			form_wrapper.stop().animate({
                      height	 : target_height,
				marginTop: target == '#reg_form' ? 0 : ( - (target_height/2) - 24),
				top: target == '#reg_form' ? 0 : '50%'
                  },500,function(){
                      $(target).fadeIn(400);
                      $('.links_btm .linkform').toggle();
				$(form_wrapper).css({
					'height'		: ''
				});
                  });
		});
		e.preventDefault();
	});

	//* validation
	$('#login_form').validate({
		onkeyup: false,
		errorClass: 'error',
		validClass: 'valid',
		rules: {
			"user[email]": { required: true, minlength: 3 },
			"user[password]": { required: true, minlength: 3 }
		},
		highlight: function(element) {
			$(element).closest('div').addClass("f_error");
			setTimeout(function() {
				boxHeight()
			}, 200)
		},
		unhighlight: function(element) {
			$(element).closest('div').removeClass("f_error");
			setTimeout(function() {
				boxHeight()
			}, 200)
		},
		errorPlacement: function(error, element) {
			$(element).closest('div').append(error);
		}
	});

	$('#pass_form').validate({
		onkeyup: false,
		errorClass: 'error',
		validClass: 'valid',
		rules: {
			"user[email]": { required: true, minlength: 3 },
		},
		highlight: function(element) {
			$(element).closest('div').addClass("f_error");
			setTimeout(function() {
				boxHeight()
			}, 200)
		},
		unhighlight: function(element) {
			$(element).closest('div').removeClass("f_error");
			setTimeout(function() {
				boxHeight()
			}, 200)
		},
		errorPlacement: function(error, element) {
			$(element).closest('div').append(error);
		}
	});

	$('#confirm_form').validate({
		onkeyup: false,
		errorClass: 'error',
		validClass: 'valid',
		rules: {
			"user[email]": { required: true, minlength: 3 },
		},
		highlight: function(element) {
			$(element).closest('div').addClass("f_error");
			setTimeout(function() {
				boxHeight()
			}, 200)
		},
		unhighlight: function(element) {
			$(element).closest('div').removeClass("f_error");
			setTimeout(function() {
				boxHeight()
			}, 200)
		},
		errorPlacement: function(error, element) {
			$(element).closest('div').append(error);
		}
	});

	$('#edit_pass_form').validate({
		onkeyup: false,
		errorClass: 'error',
		validClass: 'valid',
		rules: {
			"user[password]": { required: true, minlength: 6 },
			"user[password_confirmation]": { required: true, minlength: 6 },
		},
		highlight: function(element) {
			$(element).closest('div').addClass("f_error");
			setTimeout(function() {
				boxHeight()
			}, 200)
		},
		unhighlight: function(element) {
			$(element).closest('div').removeClass("f_error");
			setTimeout(function() {
				boxHeight()
			}, 200)
		},
		errorPlacement: function(error, element) {
			$(element).closest('div').append(error);
		}
	});

	if($('#reg_form').find('input[name="company[plan]"]').val() == 'free')
	{
		$("#payment_verification").hide();

		$('#reg_form').find('.payment_field').addClass('ignore');
	}

	$('#reg_form').find('input[name="company[plan]"]').change(function(){
		var plan = $(this).val();

    if(plan == 'free')
    {
    	$("#payment_verification").hide();
      $('#reg_form').find('.payment_field').addClass('ignore');
    }
    else
    {
    	$("#payment_verification").show();
      $('#reg_form').find('.payment_field').removeClass('ignore');
    }

	});

	$('#reg_form').validate({
		onkeyup: false,
		errorClass: 'error',
		validClass: 'valid',
		ignore: ".ignore",
		rules: {
			"user[password]": { required: true, minlength: 6 },
			"user[password_confirmation]": { required: true, minlength: 6 },
			"user[email]": { required: true },
			"user[first_name]": { required: true },
			"user[last_name]": { required: true },
			"user[company_subdomain]": { required: true },
			"user[payment_verification][account_holder]": { required: true },
			"user[payment_verification][account_number]": { required: true },
			"user[payment_verification][account_verification]": { required: true },
			"user[payment_verification][name_family]": { required: true },
			"user[payment_verification][name_give]": { required: true },
			"user[payment_verification][contact_email]": { required: true },
			"user[payment_verification][address_city]": { required: true },
			"user[payment_verification][address_street]": { required: true }
		},
		highlight: function(element) {
			$(element).closest('div').addClass("f_error");
			setTimeout(function() {

			}, 200)
		},
		unhighlight: function(element) {
			$(element).closest('div').removeClass("f_error");
			setTimeout(function() {

			}, 200)
		},
		errorPlacement: function(error, element) {
			$(element).closest('div').append(error);
		}
	});

});


//* tooltips
gebo_tips = {
	init: function() {
		if(!is_touch_device()){
			var shared = {
			style		: {
					classes: 'ui-tooltip-shadow ui-tooltip-tipsy'
				},
				show		: {
					delay: 100,
					event: 'mouseenter focus'
				},
				hide		: { delay: 0 }
			};
			if($('.ttip_b').length) {
				$('.ttip_b').qtip( $.extend({}, shared, {
					position	: {
						my		: 'top center',
						at		: 'bottom center',
						viewport: $(window)
					}
				}));
			}
			if($('.ttip_t').length) {
				$('.ttip_t').qtip( $.extend({}, shared, {
					position: {
						my		: 'bottom center',
						at		: 'top center',
						viewport: $(window)
					}
				}));
			}
			if($('.ttip_l').length) {
				$('.ttip_l').qtip( $.extend({}, shared, {
					position: {
						my		: 'right center',
						at		: 'left center',
						viewport: $(window)
					}
				}));
			}
			if($('.ttip_r').length) {
				$('.ttip_r').qtip( $.extend({}, shared, {
					position: {
						my		: 'left center',
						at		: 'right center',
						viewport: $(window)
					}
				}));
			};
		}
	}
};

//* popovers
gebo_popOver = {
    init: function() {
        $(".pop_over").popover({style: {classes: 'min_tips'}});
    }
};