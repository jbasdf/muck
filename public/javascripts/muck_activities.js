jQuery(document).ready(function() {
	jQuery('.activity-no-comments').hide();
	hide_comment_boxes();
	jQuery('.activity-has-comments').find('textarea').click(function(){
		show_comment_box(this);
	});
	jQuery('.activity-has-comments').find('textarea').blur(function(){
		textarea = jQuery(this);
		if (textarea.val() == ''){
			hide_comment_boxes();
		}
	});
});

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
	textarea.siblings('.actor-icon').show();
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