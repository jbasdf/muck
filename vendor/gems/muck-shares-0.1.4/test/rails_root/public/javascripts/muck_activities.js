jQuery(document).ready(function() {
	apply_share_methods();
});

function apply_share_methods(){
	setup_share_submit();
	hide_share_boxes();
	apply_share_hover();
	apply_activity_hover();
	jQuery('.activity-no-shares').hide();
	
	jQuery('.activity-has-shares').find('textarea').click(function(){
		show_share_box(this);
	});
	jQuery('.activity-has-shares').find('textarea').blur(function(){
		textarea = jQuery(this);
		if (textarea.val() == ''){
			hide_share_boxes();
		}
	});
	
	jQuery(".make-share").unbind();
	jQuery('.make-share').click(function(){
		var id = this.id.replace('make_share_activity_', '');
		var share_box = jQuery('#share_activity_' + id);
		share_box.find('textarea').removeClass('min');
		share_box.find('textarea').addClass('max');
		share_box.show();
		share_box.find('textarea').get(0).focus();
		share_box.find('textarea').blur(function(){
			if (jQuery(this).val() == ''){
				jQuery(this).closest('.activity-share').hide();
			}
		});
		return false;
	});
}

function setup_share_submit(){
	jQuery(".share-submit").unbind();
	jQuery(".share-submit").click(function() {
    jQuery(this).hide();
		jQuery(this).parents('.share-form-wrapper').siblings('.actor-icon').hide();
		jQuery(this).siblings('textarea').hide();
		jQuery(this).parent().append('<p class="share-loading"><img src="/images/spinner.gif" alt="loading..." /> ' + ADD_COMMENT_MESSAGE + '</p>');
		var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action'), form.serialize() + '&format=json',
      function(data){
        var json = eval('(' + data + ')');
        if(!json.success){
          jQuery.jGrowl.info(json.message);
        } else {
					jQuery('.share-loading').remove();
					jQuery('.activity-has-shares').find('textarea').show();
					var share_box = jQuery('#share_activity_' + json.parent_id);
					share_box.before(json.html);
					share_box.removeClass('activity-no-shares');
					share_box.addClass('activity-has-shares');
					share_box.find('textarea').show();
					apply_share_methods();
				}
      });
    return false;
  });
}

function hide_share_boxes(){
	jQuery('.activity-has-shares').children('.actor-icon').hide();
	jQuery('.activity-has-shares').find('.button').hide();
	jQuery('.activity-has-shares').find('textarea').val(COMMENT_PROMPT);
	jQuery('.activity-has-shares').find('textarea').addClass('min');
}

function show_share_box(obj){
	textarea = jQuery(obj);
	textarea.addClass('max');
	textarea.removeClass('min');
	textarea.closest('.share-form-wrapper').siblings('.actor-icon').show();
	textarea.siblings('.button').show();
	if (textarea.val() == COMMENT_PROMPT) {
		textarea.val('');
	}
}

function get_latest_activity_id(){
  var activities = jQuery('#activity-feed-content').children('.activity');
  if(activities.length > 0){
    return activities[0].id.replace('activity_', '');
  } else {
    return '';
  }
}

function update_feed(request){
  jQuery('#activity-feed-content').prepend(request);
}

function apply_activity_hover(){
	jQuery('.activity-content').hover(
     function () { jQuery(this).addClass('activity-hover'); }, 
     function () { jQuery(this).removeClass('activity-hover'); } );
}

function apply_share_hover(){
	jQuery('.activity-share').hover(
     function () { jQuery(this).addClass('share-hover'); }, 
     function () { jQuery(this).removeClass('share-hover'); } );
}