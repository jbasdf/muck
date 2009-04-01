jQuery(document).ready(function() {
	jQuery(".tip-field").focus(function() {
		jQuery(".active").removeClass("active");
		var tip_key = jQuery('#' + this.id).siblings('#tip-key');
		var control_id = this.id;
		var help_id = this.id;
		if (tip_key.length > 0){
			control_id = tip_key.html();
			help_id = jQuery('#' + this.id).siblings('#tip-id').html();
		}		
		var tip_text = jQuery('#' + help_id + "-help").html();
		var tip_title = jQuery('#' + help_id + "-help-title").html();		
		var width = 400;
		show_tip(control_id, tip_title, tip_text, width);
		jQuery("#" + help_id + "-container").addClass("active");
	});
	
	jQuery(".tip-field").blur(function() {
		jQuery('#tip').remove();
	});
	
	jQuery(".required-value").blur(function() {
		if (jQuery(this).val().length == 0) {
			jQuery('#' + this.id + '_required').show();
		} else {
			jQuery('#' + this.id + '_required').hide();
			jQuery('#' + this.id + '-label-required').hide();
		}
	});

	jQuery(".delete-container").click(function() {
		jQuery(this).parent().remove();
  });

});

function show_tip(object_id,title,tip_text,width){
	if(title == false || title == null)title="&nbsp;";	
	var de = document.documentElement;
	var w = self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
	var hasArea = w - getAbsoluteLeft(object_id);
	var clickElementy = getAbsoluteTop(object_id) - 3; //set y position
	
	if(hasArea>((width*1)+75)){
		$("body").append("<div id='tip' style='width:"+width*1+"px'><div id='tip_arrow_left'></div><div id='tip_close_left'>"+title+"</div><div id='tip_copy'><div class='tip_loader'>"+tip_text+"<div></div></div>");//right side
		var arrowOffset = getElementWidth(object_id) + 11;
		var clickElementx = getAbsoluteLeft(object_id) + arrowOffset; //set x position
	}else{
		$("body").append("<div id='tip' style='width:"+width*1+"px'><div id='tip_arrow_right' style='left:"+((width*1)+1)+"px'></div><div id='tip_close_right'>"+title+"</div><div id='tip_copy'><div class='tip_loader'>"+tip_text+"<div></div></div>");//left side
		var clickElementx = getAbsoluteLeft(object_id) - ((width*1) + 15); //set x position
	}
	
	$('#tip').css({left: clickElementx+"px", top: clickElementy+"px"});
	$('#tip').show();
}

function getElementWidth(objectId) {
	x = document.getElementById(objectId);
	return x.offsetWidth;
}

function getAbsoluteLeft(objectId) {
	// Get an object left position from the upper left viewport corner
	o = document.getElementById(objectId)
	oLeft = o.offsetLeft            // Get left position from the parent object
	while(o.offsetParent!=null) {   // Parse the parent hierarchy up to the document element
		oParent = o.offsetParent    // Get parent object reference
		oLeft += oParent.offsetLeft // Add parent left position
		o = oParent
	}
	return oLeft
}

function getAbsoluteTop(objectId) {
	// Get an object top position from the upper left viewport corner
	o = document.getElementById(objectId)
	oTop = o.offsetTop            // Get top position from the parent object
	while(o.offsetParent!=null) { // Parse the parent hierarchy up to the document element
		oParent = o.offsetParent  // Get parent object reference
		oTop += oParent.offsetTop // Add parent top position
		o = oParent
	}
	return oTop
}