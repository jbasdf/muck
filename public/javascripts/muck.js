//jQuery.noConflict();
jQuery(document).ajaxSend(function(event, request, settings) {
  request.setRequestHeader("Accept", "text/javascript");
  request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

  if (settings.type.toUpperCase() == 'GET' || typeof(AUTH_TOKEN) == "undefined") return; // for details see: http://www.justinball.com/2009/07/08/jquery-ajax-get-in-firefox-post-in-internet-explorer/
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
 	if (typeof(AUTH_TOKEN) != "undefined")
  	settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

function setup_submit_delete(){
	jQuery(".submit-delete").click(function() {
		// if(!confirm("Are you sure?")){
		// 	return false;
		// }
    jQuery(this).parents('.delete-container').fadeOut();
    var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action') + '.json', form.serialize(),
      function(data){
        var json = eval('(' + data + ')');
        if(!json.success){
          jQuery.jGrowl.info(json.message);
        }
      });
    return false;
  });
	jQuery(".submit-delete-js").click(function() {
		// if(!confirm("Are you sure?")){
		// 	return false;
		// }
    jQuery(this).parents('.delete-container').fadeOut();
    var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action') + '.js', form.serialize(),
      function(data){
      });
    return false;
  });
}

function show_hide_obj (ary_objs_to_show, ary_objs_to_hide)
{
 	for (i=0;i<ary_objs_to_show.length;i++) {
 		if (obj_to_show = document.getElementById(ary_objs_to_show[i])) obj_to_show.style.display="";
 		if (tab = document.getElementById('anchor'+ary_objs_to_show[i])) tab.className = 'curTab';
 	}
 	for (i=0;i<ary_objs_to_hide.length;i++) {
 		if (obj_to_hide = document.getElementById(ary_objs_to_hide[i])) obj_to_hide.style.display="none";
 		if (tab = document.getElementById('anchor'+ary_objs_to_hide[i])) tab.className = '';
 	}
}

function setup_country(force_load){

	var country_id = jQuery("#countries").val();
	var state_id = jQuery("#states").val();

	if (country_id == undefined){ 
		return; 
	}

	if (country_id == '-1'){
		jQuery("#states").val('-1');
		jQuery("#counties").val('-1');
	}

	if (country_id == '-1' || country_id == ''){
		jQuery("#states-container").hide();
		jQuery("#counties-container").hide();
		return;
	}

	if(force_load || state_id == '' || state_id == null || state_id == -1) {
		jQuery.getJSON("/helper/load_states_for_country/" + country_id + ".js", function(data){
			var options = '';
			jQuery("#counties-container").hide();
			jQuery('#states-container label').html(data.label);
			states = data.states;
			if(states.length > 0){
				for (var i = 0; i < states.length; i++) {
					var state_id = states[i].state.id;
					if(state_id == undefined) { state_id = ''; }
					options += '<option value="' + state_id + '">' + states[i].state.name + '</option>';
				}
				jQuery("#states-container").show();
				jQuery("select#states").html(options);
			} else {
				jQuery("#states-container").hide();
			}
		});
	}
}

jQuery.jGrowl.defaults.position = 'center';

jQuery.jGrowl.info = function(msg){
	jQuery.jGrowl(msg);
}

jQuery.jGrowl.warn = function(msg){
	jQuery.jGrowl(msg);	
}

jQuery.jGrowl.error = function(msg){
	jQuery.jGrowl(msg, {sticky:true,header:"Please correct the following errors:"});	
}

jQuery(document).ready(function() {
	jQuery("#global-login").focus(function() {
		jQuery("#global-login").val("");
	});
	jQuery("#global-password").focus(function() {
		jQuery("#global-password").val("");
	});
	jQuery("#quick-login-submit").click(function() {
		jQuery("#quick-login").submit();
	});
	
	jQuery("#countries-container select").change(function() {
		setup_country(true);
  });
	if(jQuery("#states").val() == '' || jQuery("#states").val() == null) {
		jQuery("#states-container").hide();
	}
	setup_country(false);
});