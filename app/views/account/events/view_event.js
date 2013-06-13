$("#search_results").slideUp("fast");
$('#main_contents').hide("fast");
$('#main_contents').load("<%= view_account_event_path %>");
$('#main_contents').show("slow");
