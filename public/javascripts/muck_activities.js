jQuery(document).ready(function() {
	apply_comment_methods();
});

function apply_comment_methods(){
	setup_comment_submit();
	hide_comment_boxes();
	jQuery('.activity-no-comments').hide();
	
	jQuery('.activity-has-comments').find('textarea').click(function(){
		show_comment_box(this);
	});
	jQuery('.activity-has-comments').find('textarea').blur(function(){
		textarea = jQuery(this);
		if (textarea.val() == ''){
			hide_comment_boxes();
		}
	});
	
	jQuery('.make-comment').click(function(){
		var id = this.id.replace('make_comment_activity_', '');
		var comment_box = jQuery('#comment_activity_' + id);
		comment_box.find('textarea').removeClass('min');
		comment_box.find('textarea').addClass('max');
		comment_box.show();
		comment_box.find('textarea').get(0).focus();
		comment_box.find('textarea').blur(function(){
			if (jQuery(this).val() == ''){
				jQuery(this).closest('.activity-comment').hide();
			}
		});
		return false;
	});
}

function setup_comment_submit(){
	jQuery(".comment-submit").click(function() {
    hide_comment_boxes();
		
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
}

function hide_comment_boxes(){
	jQuery('.activity-has-comments').children('.actor-icon').hide();
	jQuery('.activity-has-comments').find('.button').hide();
	jQuery('.activity-has-comments').find('textarea').val(COMMENT_PROMPT);
	jQuery('.activity-has-comments').find('textarea').addClass('min');
}

function show_comment_box(obj){
	textarea = jQuery(obj);
	textarea.addClass('max');
	textarea.removeClass('min');
	textarea.closest('.comment-form-wrapper').siblings('.actor-icon').show();
	textarea.siblings('.button').show();
	if (textarea.val() == COMMENT_PROMPT) {
		textarea.val('');
	}
}

function get_latest_activity_id(){
  var activities = jQuery('#activity-feed-content').children('.activity-status-update');
  if(activities.length > 0){
    return activities[0].id.replace('activity_', '');
  } else {
    return '';
  }
}

function update_feed(request){
  jQuery('#activity-feed-content').prepend(request);
}