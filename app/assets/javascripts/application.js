////////////////////////////////////////////////////////////////
// require jquery
// require jquery_ujs
// require js-routes

// require ./gebo_admin_1.4/js/jquery.debouncedresize.min
// require ./gebo_admin_1.4/js/jquery.actual.min
// require ./gebo_admin_1.4/js/jquery.cookie.min
// require ./gebo_admin_1.4/bootstrap/js/bootstrap.min
// require ./gebo_admin_1.4/js/bootstrap.plugins.min
// require ./gebo_admin_1.4/lib/jquery-ui/jquery-ui-1.8.20.custom.min
// require ./gebo_admin_1.4/js/forms/jquery.ui.touch-punch.min
// require ./gebo_admin_1.4/lib/qtip2/jquery.qtip.min
// require ./gebo_admin_1.4/js/ios-orientationchange-fix
// require ./gebo_admin_1.4/lib/antiscroll/antiscroll
// require ./gebo_admin_1.4/lib/antiscroll/jquery-mousewheel
// require ./gebo_admin_1.4/lib/fullcalendar/fullcalendar.min
// require ./gebo_admin_1.4/lib/fullcalendar/gcal
// require ./gebo_admin_1.4/lib/datatables/jquery.dataTables.min
// require ./gebo_admin_1.4/lib/datatables/extras/Scroller/media/js/Scroller.min
// require ./gebo_admin_1.4/lib/datepicker/bootstrap-datepicker.min
// require ./gebo_admin_1.4/lib/datepicker/bootstrap-timepicker.min
// require ./gebo_admin_1.4/lib/floating_header/jquery.list.min
// require ./gebo_admin_1.4/js/forms/jquery.autosize.min
// require ./gebo_admin_1.4/lib/chosen/chosen.jquery.min
// require ./gebo_admin_1.4/js/gebo_common
// require ./gebo_admin_1.4/lib/sticky/sticky.min
// require ./gebo_admin_1.4/lib/validation/jquery.validate.min
// require ./gebo_admin_1.4/lib/stepy/jquery.stepy.min
// require jquery.validate

// require jquery-fileupload/basic
// require jquery-fileupload/vendor/tmpl
// require_self
////////////////////////////////////////////////////////////////////

//= require jquery
//= require jquery_ujs
//= require js-routes


//= require ./flat/plugins/nicescroll/jquery.nicescroll.min

//= require ./flat/plugins/jquery-ui/jquery.ui.core.min
//= require ./flat/plugins/jquery-ui/jquery.ui.widget.min
//= require ./flat/plugins/jquery-ui/jquery.ui.mouse.min
//= require ./flat/plugins/jquery-ui/jquery.ui.draggable.min
//= require ./flat/plugins/jquery-ui/jquery.ui.resizable.min
//= require ./flat/plugins/jquery-ui/jquery.ui.sortable.min
//= require ./flat/plugins/jquery-ui/jquery.ui.slider

//= require ./flat/plugins/touch-punch/jquery.touch-punch.min
// require ./flat/plugins/slimscroll/jquery.slimscroll.min
//= require ./flat/bootstrap.min
//= require ./flat/plugins/bootbox/jquery.bootbox
// require ./flat/plugins/flot/jquery.flot.min
// require ./flat/plugins/flot/jquery.flot.bar.order.min
// require ./flat/plugins/flot/jquery.flot.pie.min
// require ./flat/plugins/flot/jquery.flot.resize.min
//= require ./flat/plugins/imagesLoaded/jquery.imagesloaded.min
// require ./flat/plugins/pageguide/jquery.pageguide
//= require ./flat/plugins/fullcalendar/fullcalendar.min
//= require ./flat/eakroko.min
// require ./gebo_admin_1.4/lib/jquery-ui/jquery-ui-1.8.20.custom.min


//= require ./gebo_admin_1.4/lib/qtip2/jquery.qtip.min
// require ./flat/plugins/datatable/jquery.dataTables.min
// require ./flat/plugins/datatable/dataTables.scroller.min
//= require ./gebo_admin_1.4/lib/datatables/jquery.dataTables.min
// require ./gebo_admin_1.4/lib/datatables/extras/Scroller/media/js/Scroller.min
//= require ./gebo_admin_1.4/lib/datepicker/bootstrap-timepicker.min
//= require ./flat/plugins/datepicker/bootstrap-datepicker
//= require ./flat/plugins/chosen/chosen.jquery.min
//= require ./flat/plugins/validation/jquery.validate.min
// require ./flat/plugins/datatable/jquery.dataTables.min
// require ./flat/plugins/datatable/TableTools.min.js
// require ./flat/plugins/datatable/ColReorder.min
// require ./flat/plugins/datatable/ColVis.min
// require ./flat/plugins/datatable/jquery.dataTables.columnFilter


//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require extensions
//= require_self


var	GeboDatatbles = {
	dt_users: function(url) {
    if($('#dt_users').length){

      $('#dt_users').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "sPaginationType": "bootstrap",
        "sDom": "<<'span3'l><'span6'f>r>t<'row'<'span3'i><'span6'p>>",
        "sAjaxSource": url,
        "aoColumns": [
          null,
          null,
          null,
          null,
          {"bSortable": false}
        ],
        "aaSorting": [[0, 'asc']],
      });
    }
	},

  dt_companies: function(url) {
    if($('#dt_companies').length){

      $('#dt_companies').dataTable({
      	"bProcessing": true,
				"bServerSide": true,
        "sPaginationType": "bootstrap",
        "sDom": "<<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
        "sAjaxSource": url,
        "aoColumns": [ {"bSortable": false}, null, null, {"bSortable": false}],
				"aaSorting": [[1, 'asc']],
      });
    }
  },

  dt_branches: function(url) {
    if($('#dt_branches').length){

      $('#dt_branches').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "sPaginationType": "bootstrap",
        "sDom": "<<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
        "sAjaxSource": url,
        "aoColumns": [ {"bSortable": false, "sWidth": "10%"}, {"sWidth": "15%"}, {"bSortable": false, "sWidth":"20%"}, {"bSortable": false, "sWidth": "30%"}, {"bSortable": false, "sWidth" : "10%"}],
        "aaSorting": [[1, 'asc']],
      });
    }
  },

  dt_events: function(url) {
    if($('#dt_events').length){

      $('#dt_events').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "sPaginationType": "bootstrap",
        "sDom": "<<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
        "sAjaxSource": url,
        "aoColumns": [
          null,
          null,
          null,
          null,
          null,
          {"bSortable": false},
          null,
          {"bSortable": false}
        ],
        "aaSorting": [[4, 'asc']],
      });
    }
  },

  dt_services: function(url) {
    if($('#dt_services').length){

      $('#dt_services').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "sPaginationType": "bootstrap",
        "sDom": "<<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
        "sAjaxSource": url,
        "aoColumns": [ {"bSortable": false, "sWidth": "4%"}, null, {"bSortable": false}, null, null, {"bSortable": false}],
        "aaSorting": [],
      });
    }
  },
  
  dt_customers: function(url) {

    if($('#dt_customers').length){
      $('#dt_customers').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "sPaginationType": "bootstrap",
        "sDom": "<<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
        "sAjaxSource": url,
        "aoColumns": [ {"bVisible":false}, {"bSortable": false, "bVisible":true}, null, {"bSortable": false, "bVisible":true}],
        "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
          var klass = aData[0];
          $(nRow).attr("class",klass);
          return nRow;
        },
        "aaSorting": [],
      });
    }
  },
  
  dt_apptcustomers: function(url) {

    if($('#dt_customers').length){
      $('#dt_customers').dataTable({
        "bProcessing": true,
        "bServerSide": true,
        "sPaginationType": "bootstrap",
        "sDom": "<<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
        "sAjaxSource": url,
        "aoColumns": [ {"bVisible":false}, {"bSortable": false, "bVisible":true}, null, {"bSortable": false, "bVisible":true}],
        "fnRowCallback": function( nRow, aData, iDisplayIndex ) {
          var klass = aData[0];
          $(nRow).attr("class",klass);
          return nRow;
        },
        "aaSorting": [],
      });
    }
  },
  
  
  
  
  
}

var GeboFloatingHeader = {
  fh_users: function(){
    var $list_b = $('#fh_users');

    // Generate the list of buttons for the scrollto links.
    $('<div id="list-buttons"/>').insertBefore($list_b);

    $list_b.find('dt').each(function(i){
      var this_dd = $(this),
                  dd_length = $('+ dd',this_dd).nextUntil('dt').length + 1;
              // Create the new button element for this header.
      $('#list-buttons').append('<button data-header="'+i+'" class="btn btn-mini bstr_ttip" title="'+dd_length+'">'+$(this).text()+'</button>');
    });

    if(!is_touch_device()){
      //* add tooltip
        $('.bstr_ttip').tooltip();
    }

    //* add the list plugin.
    $list_b.list();

    var dd_height = $list_b.find('.ui-list dd').outerHeight(),
              dt_height = $list_b.find('.ui-list dt').outerHeight(),
              fake_header = $list_b.find('.-list-fakeheader');

    //* add an event handler
    $('#list-buttons').on('click', 'button', function(){
      $('#list-buttons button').removeClass('btn-success');
      $(this).addClass('btn-success');

      var this_index = $(this).data('header'),
        this_dt = $list_b.find('.ui-list dt').eq(this_index);
              //* fix fakeheader text
      function updateHeader() {
        fake_header.html(this_dt.html());
      };

      //* update container height
      var dd_length = $('+ dd',this_dt).nextUntil('dt').length + 1;
          $list_b.animate({ height: (dt_height + (dd_length * dd_height) - 2) }, 100);

      // Scroll to the selected element.
      $list_b.list( 'scrollTo', this_index, 400, function(){
                  setTimeout(updateHeader,0);
              } );

    });
          //* hide scrollbar
    $list_b.find('.ui-list').css('overflow-y','hidden');

    //* adjust fakeHeader width
    fake_header.width(fake_header.width() + 15);

    //* set first element
    $('#list-buttons button:first').trigger('click');

  }
}

var Appointments = {
  filter_setup: function(url){
    $("#staff_filter").change(function() {
      Application.load_content(url,
        {
          service_filter: $("#service_filter").val(),
          staff_filter: $("#staff_filter").val(),
          start_date_filter: $("#start_date_filter").val(),
          end_date_filter: $("#end_date_fitler").val()
        }
      );
    });

    $("#service_filter").change(function() {
      Application.load_content(url,
        {
          service_filter: $("#service_filter").val(),
          staff_filter: $("#staff_filter").val(),
          start_date_filter: $("#start_date_filter").val(),
          end_date_filter: $("#end_date_fitler").val()
        }
      );
    });

    $("#start_date_filter").change(function(){
      Application.load_content(url,
        {
          service_filter: $("#service_filter").val(),
          staff_filter: $("#staff_filter").val(),
          start_date_filter: $("#start_date_filter").val(),
          end_date_filter: $("#end_date_fitler").val()
        }
      );
    });

    $("#end_date_fitler").change(function(){
      Application.load_content(url,
        {
          service_filter: $("#service_filter").val(),
          staff_filter: $("#staff_filter").val(),
          start_date_filter: $("#start_date_filter").val(),
          end_date_filter: $("#end_date_fitler").val()
        }
      );
    });
  }
}


  $('.all_appointments').live('click',function() {
			$('.accordion-heading').removeClass('sdb_h_active');
      $('.side_menu_appointment').addClass('sdb_h_active');

      Application.load_content($(this).data("path"));
  }); 

	$(".move_up").live("click", function(dis){
		var id = $(this).attr("data-id");
		$.get("/account/services/" + id + "/move_up.js");
	})

	$(".move_down").live("click", function(dis){
		var id = $(this).attr("data-id");
		$.get("/account/services/" + id + "/move_down.js");
	})

  // FLAT THEME ///////////////////////////////////////////

  function slimScrollUpdate(elem, toBottom) {
      if(elem.length > 0){
          var height = parseInt(elem.attr('data-height')),
          vis = (elem.attr("data-visible") == "true") ? true : false,
          start = (elem.attr("data-start") == "bottom") ? "bottom" : "top";
          var opt = {
              height: height,
              color: "#666",
              start: start
          };
          if (vis) {
              opt.alwaysVisible = true;
              opt.disabledFadeOut = true;
          }
          if (toBottom !== undefined) opt.scrollTo = toBottom+"px";
          elem.slimScroll(opt);
      }
  }

  function destroySlimscroll(elem) { 
      elem.parent().replaceWith(elem); 
  }

  function initSidebarScroll(){
      getSidebarScrollHeight();
      if(!$("#left").hasClass("hasScroll")){
          $("#left").niceScroll({
              cursorborder: 0,
              cursorcolor: '#999',
              railoffset:{
                  top:0,
                  left:-2
              },
              autohidemode:false,
              horizrailenabled:false
          });
          $("#left").addClass("hasScroll");
      } else {
          $("#left").getNiceScroll().resize().show();
      }
  }

  function getSidebarScrollHeight(){
      var $el = $("#left"),
      $w = $(window),
      $nav = $("#navigation");
      var height = $w.height();

      if($nav.hasClass("navbar-fixed-top") || $w.scrollTop() == 0) height -= 40;

      if($el.hasClass("sidebar-fixed")) $el.height(height);
  }

  function checkLeftNav(){
      var $w = $(window),
      $content = $("#content"),
      $left = $("#left");
      if($w.width() <= 767){
          $left.hide();
          $("#main").css("margin-left", 0 );
          if($(".toggle-mobile").length == 0){
              $("#navigation .user").before('<a href="#" class="toggle-mobile"><i class="icon-reorder"></i></a>');
          }

          if($(".mobile-nav").length == 0){
              createSubNav();
          }
        
          if(!$content.hasClass("nav-fixed")){
              $content.addClass("nav-fixed forced-fixed");
              $("#navigation").addClass("navbar-fixed-top");
          }
      } else {
          if(!$left.is(":visible") && !$left.hasClass("forced-hide")){
              $left.show();
              $("#main").css("margin-left", $left.width());
          }

          $(".toggle-mobile").remove();
          $(".mobile-nav").removeClass("open");

          if($content.hasClass("forced-fixed")){
           $content.removeClass("nav-fixed");
           $("#navigation").removeClass("navbar-fixed-top");
       }

       if($w.width() < 1200) {
          if($("#navigation .container").length > 0){
              // it is fixed layout -> reset to fluid
              $(".version-toggle .set-fluid").trigger("click");
          }
      }
  }
  }

  function resizeHandlerHeight(){
      var wHeight = $(window).height(),
      minus = ($(window).scrollTop() == 0) ? 40 : 0;
      $("#left .ui-resizable-handle").height(wHeight-minus);
  }

  function toggleMobileNav(){
      var mobileNav = $(".mobile-nav");
      mobileNav.toggleClass("open");
  }

  function createSubNav(){
      if($(".mobile-nav").length == 0){
          var original = $("#navigation .main-nav");
          $("#navigation .main-nav").parent().after("<ul class='mobile-nav'></ul>");
          var mobile = $(".mobile-nav");

          original.find("> li > a").each(function(e){
              var mainElement = $(this),
              subElements = "",
              arrow = "";
              if(mainElement.hasClass("dropdown-toggle")){
                  arrow = " <i class='icon-angle-left'></i>";
                  subElements += "<ul>";
                  mainElement.parent().find(".dropdown-menu > li > a").each(function(){
                      subElements += "<li><a href='"+$(this).attr("href")+"'>"+$(this).text()+"</a></li>";
                  });
                  subElements += "</ul>";
              }
              mobile.append("<li><a href='"+mainElement.attr("href")+"'>"+mainElement.text()+arrow+"</a>"+subElements+"</li>");
          });

          $(".mobile-nav > li > a").click(function(e){
              var el = $(this);
              if(el.next().length !== 0){
                  e.preventDefault();

                  var sub = el.next();
                  el.parents(".mobile-nav").find(".open").not(sub).each(function(){
                      var t = $(this);
                      t.removeClass("open");
                      t.prev().find("i").removeClass("icon-angle-down").addClass("icon-angle-left");
                  });
                  sub.toggleClass("open");
                  el.find("i").toggleClass('icon-angle-left').toggleClass("icon-angle-down");
              }
          });
      }
  }

  function initTopbarCollisionDetection(){
      var $el = $(".icon-nav"),
      $userMenu = $(".user .dropdown").last(),
      $w = $(window),
      $mainNav = $(".main-nav"),
      mainNavOffsetLeft = 200,
      horizontalPadding = 20,
      tolerance = 20;
      var lastCollisionOn = 0;

      $userMenu.imagesLoaded(function(){
          $w.resize(function(){
              var collisionOn = $el.outerWidth(true) + $userMenu.outerWidth(true) + $mainNav.outerWidth(true) + mainNavOffsetLeft + horizontalPadding + tolerance;
              if($w.width() <= collisionOn){
                  while($w.width() <= collisionOn && $el.find(">li:visible").length > 0){
                      lastCollisionOn = collisionOn;
                      $el.find(">li:visible").first().hide();
                      collisionOn = $el.outerWidth(true) + $userMenu.outerWidth(true) + $mainNav.outerWidth(true) + mainNavOffsetLeft + horizontalPadding;
                  }
              } else {
                  if($w.width() > lastCollisionOn){
                      while($w.width() > lastCollisionOn && $el.find(">li:hidden").length > 0){
                          $el.find(">li:hidden").last().show();
                          lastCollisionOn = collisionOn;
                      }
                  }
              }
          }).resize();
      });
  }  




  $(document).ready(function () {

      initTopbarCollisionDetection();

     createSubNav();

      // hide breadcrumbs
      $(".breadcrumbs .close-bread > a").click(function (e) {
          e.preventDefault();
          $(".breadcrumbs").fadeOut();
      });

      $("#navigation").on('click', '.toggle-mobile' , function(e){
          e.preventDefault();
          console.log("asdf");
          toggleMobileNav();
      });

      $(".content-slideUp").click(function (e) {
          e.preventDefault();
          var $el = $(this),
          content = $el.parents('.box').find(".box-content");
          content.slideToggle('fast', function(){
             $el.find("i").toggleClass('icon-angle-up').toggleClass("icon-angle-down");
             if(!$el.find("i").hasClass("icon-angle-up")){
              if(content.hasClass('scrollable')) slimScrollUpdate(content);
          } else {
              if(content.hasClass('scrollable')) destroySlimscroll(content);
          }
      });
      });

      $(".content-remove").click(function (e) {
          e.preventDefault();
          var $el = $(this);
          var spanElement = $el.parents("[class*=span]");
          var spanWidth = parseInt(spanElement.attr('class').replace("span", "")),
          previousElement = (spanElement.prev().length > 0) ? spanElement.prev() : spanElement.next();
          if(previousElement.length > 0){
              var prevSpanWidth = parseInt(previousElement.attr("class").replace("span", ""));
          }
          bootbox.animate(false);
          bootbox.confirm("Do you really want to remove the widget <strong>" + $el.parents(".box-title").find("h3").text() + "</strong>?", "Cancel", "Yes, remove", function (r) {
              if (r){
                  $el.parents('[class*=span]').remove();
                  if(previousElement.length > 0){
                      previousElement.removeClass("span"+prevSpanWidth).addClass("span"+(prevSpanWidth+spanWidth));
                  }
              }
          });
      });

      $(".content-refresh").click(function (e) {
          e.preventDefault();
          var $el = $(this);
          $el.find("i").addClass("icon-spin");
          setTimeout(function () {
              $el.find("i").removeClass("icon-spin");
          }, 2000);
      });

      if($('#vmap').length > 0)
      {
       $('#vmap').vectorMap({
          map: 'world_en',
          backgroundColor: null,
          color: '#ffffff',
          hoverOpacity: 0.7,
          selectedColor: '#2d91ef',
          enableZoom: true,
          showTooltip: false,
          values: sample_data,
          scaleColors: ['#8cc3f6', '#5c86ac'],
          normalizeFunction: 'polynomial'
      });
   }

   $(".custom-checkbox").each(function () {
      var $el = $(this);
      if ($el.hasClass("checkbox-active")) {
          $el.find("i").toggleClass("icon-check-empty").toggleClass("icon-check");
      }
      $el.bind('click', function (e) {
          e.preventDefault();
          $el.find("i").toggleClass("icon-check-empty").toggleClass("icon-check");
          $el.toggleClass("checkbox-active");
      });
  });

   $(".toggle-subnav").click(function (e) {
      e.preventDefault();
      var $el = $(this);
      $el.parents(".subnav").toggleClass("subnav-hidden").find('.subnav-menu,.subnav-content').slideToggle("fast");
      $el.find("i").toggleClass("icon-angle-down").toggleClass("icon-angle-right");
  });


   $("#left").sortable({
      items:".subnav",
      placeholder: "widget-placeholder",
      forcePlaceholderSize: true,
      axis: "y",
      handle:".subnav-title",
      tolerance:"pointer"
  });

   if($(".scrollable").length > 0){
      $('.scrollable').each(function () {
          var $el = $(this);
          var height = parseInt($el.attr('data-height')),
          vis = ($el.attr("data-visible") == "true") ? true : false,
          start = ($el.attr("data-start") == "bottom") ? "bottom" : "top";
          var opt = {
              height: height,
              color: "#666",
              start: start,
              allowPageScroll:true
          };
          if (vis) {
              opt.alwaysVisible = true;
              opt.disabledFadeOut = true;
          }
          $el.slimScroll(opt);
      });
  }

  $("#message-form .text input").on("focus", function (e) {
      var $el = $(this);
      $el.parents(".messages").find(".typing").addClass("active").find(".name").html("John Doe");
      slimScrollUpdate($el.parents(".scrollable"), 100000);
  });

  $("#message-form .text input").on("blur", function (e) {
      var $el = $(this);
      $el.parents(".messages").find(".typing").removeClass("active");
      slimScrollUpdate($el.parents(".scrollable"), 100000);
  });

  if($(".jq-datepicker").length > 0){
      $(".jq-datepicker").datepicker({
          showOtherMonths: true,
          selectOtherMonths: true,
          prevText: "",
          nextText: ""
      });
  }

  if($(".spark-me").length > 0){
      $(".spark-me").sparkline("html", {
          height: '25px',
          enableTagOptions: true
      });
  }


  if(!$("#left").hasClass("no-resize")){
      $("#left").resizable({
          minWidth: 60,
          handles: "e",
          resize: function (event, ui) {
              var searchInput = $('.search-form .search-pane input[type=text]'),
              content = $("#main");
              searchInput.css({
                  width: ui.size.width - 55
              });
              if(Math.abs(200 - ui.size.width) <= 20){
                  $("#left").css("width", 200);
                  searchInput.css("width", 145 );
                  content.css("margin-left", 200);
              } else{
                  content.css("margin-left", $("#left").width());
              }

          },
          stop: function(){
              $("#left .ui-resizable-handle").css("background","none");
          },
          start: function(){
              $("#left .ui-resizable-handle").css("background","#aaa");
          }
      });
  }

  $("[rel=popover]").popover();

  $('.toggle-nav').click(function(e){
      e.preventDefault();
      $("#left").toggle().toggleClass("forced-hide");
      if($("#left").is(":visible")) {
          $("#main").css("margin-left", $("#left").width());
      } else {
          $("#main").css("margin-left", 0);
      }
  });

  $('.table-mail .sel-star').click(function(e){
      e.preventDefault();
      e.stopPropagation();
      var $el = $(this);
      $el.toggleClass('active');
  });

  $('.table .sel-all').change(function(e){
      e.preventDefault();
      e.stopPropagation();
      var $el = $(this);
      $el.parents('.table').find("tbody .selectable").prop('checked', (el.prop('checked')));
  });

  $('.table-mail > tbody > tr').click(function(e){
      var $el = $(this);
      var checkbox = el.find('.table-checkbox > input');
      $el.toggleClass('warning');
    
      if(e.target.nodeName != 'INPUT')
      {
          checkbox.prop('checked', !(checkbox.prop('checked')));
      }
  });

  // set resize handler to corret height
  resizeHandlerHeight();

  $(".table .alpha").click(function (e) {
      e.preventDefault();
      var $el = $(this),
      str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
      elements = "",
      available = [];
      $el.parents().find('.alpha .alpha-val span').each(function(){
          available.push($(this).text());
      });

      for(var i=0; i<str.length; i++)
      {   
          var active = ($.inArray(str.charAt(i), available) != -1) ? " class='active'" : "";
          elements += "<li"+active+"><span>"+str.charAt(i)+"</span></li>";
      }
      $el.parents(".table").before("<div class='letterbox'><ul class='letter'>"+elements+"</ul></div>");
      $(".letterbox .letter > .active").click(function(){
          var $el = $(this);
          slimScrollUpdate($el.parents(".scrollable"), 0);
          var scrollToElement = $el.parents(".box-content").find(".table .alpha:contains('"+$el.text()+"')");
          slimScrollUpdate($el.parents(".scrollable"), scrollToElement.position().top);
          $el.parents(".letterbox").remove();
      });
  });

  $(".theme-colors > li > span").hover(function(e){
      var $el = $(this),
      body = $('body');
      body.attr("class","").addClass("theme-"+$el.attr("class"));
  }, function(){
      var $el = $(this),
      body = $('body');
      if(body.attr("data-theme") !== undefined) {
          body.attr("class","").addClass(body.attr("data-theme"));
      } else {
          body.attr("class","");
      }
  }).click(function(){
     var $el = $(this);
     $("body").addClass("theme-"+$el.attr("class")).attr("data-theme","theme-"+$el.attr("class"));
  });

  $(".version-toggle > a").click(function(e){
      e.preventDefault();
      e.stopPropagation();
      var $el = $(this);
      var parent = $el.parent();
      if(!$el.hasClass("active")){
          parent.find(".active").removeClass("active");
          $el.addClass("active");
      }

      if($el.hasClass("set-fixed")){
          if($(window).width() >= 1200) {
              $("#content").addClass("container").removeClass("container-fluid");
              $("#navigation .container-fluid").addClass("container").removeClass("container-fluid");
              if($("#left").hasClass("sidebar-fixed")){
                  $("#left").css("left", $("#content").offset().left);
              }
          }
      } else {
          $("#content").addClass("container-fluid").removeClass("container");
          $("#navigation .container").addClass("container-fluid").removeClass("container");
          $("#left").css("left", 0);
      }
  });

  $(".topbar-toggle > a").click(function(e){
      e.preventDefault();
      e.stopPropagation();
      var $el = $(this);
      var $parent = $el.parent();
      if(!$el.hasClass("active")){
          $parent.find(".active").removeClass("active");
          $el.addClass("active");
      }

      if($el.hasClass("set-topbar-fixed")){
          $("#content").addClass("nav-fixed");
          $("#navigation").addClass("navbar-fixed-top");
      } else {
          $("#content").removeClass("nav-fixed");
          $("#navigation").removeClass("navbar-fixed-top");
      }
  });

  $(".sidebar-toggle > a").click(function(e){
      e.preventDefault();
      e.stopPropagation();
      var $el = $(this);
      var $parent = $el.parent();
      if(!$el.hasClass("active")){
          $parent.find(".active").removeClass("active");
          $el.addClass("active");
      }  

      $(".search-form .search-pane input").attr("style", "");
      $("#main").attr("style","");

      if($el.hasClass("set-sidebar-fixed")){
          $("#left").addClass("sidebar-fixed");
          $("#left .ui-resizable-handle").css("top", 0);
          if($("#content").hasClass("container")){
              $("#left").css("left", $("#content").offset().left);
          }
          $("#left").getNiceScroll().resize().show();
          initSidebarScroll();
      } else {
          $("#left").removeClass("sidebar-fixed").css({
              "height": "auto",
              "top": "auto",
              "left": "auto"
          });
          $("#left").getNiceScroll().resize().hide();
          $("#left").removeClass("hasScroll");
      }
  });


  $(".del-gallery-pic").click(function(e){
      e.preventDefault();
      var $el = $(this);
      var $parent = $el.parents("li");
      $parent.fadeOut(400, function(){
          $parent.remove();
      });
  });

  checkLeftNav();

   // check layout
   if($("body").attr("data-layout") == "fixed"){
      $(".version-toggle .set-fixed").trigger('click');
  }

  if($("body").attr("data-layout-topbar") == "fixed"){
      $(".topbar-toggle .set-topbar-fixed").trigger("click");
  }

  if($("body").attr("data-layout-sidebar") == "fixed"){
      $(".sidebar-toggle .set-sidebar-fixed").trigger("click");
  }

});
