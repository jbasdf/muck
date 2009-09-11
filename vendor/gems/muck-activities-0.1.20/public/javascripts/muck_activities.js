jQuery(document).ready(function() {
	apply_activity_ajax_methods();
});

function apply_activity_ajax_methods(){
	setup_comment_submit();
	hide_comment_boxes();
	apply_comment_hover();
	apply_activity_hover();
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
	
	jQuery(".make-comment").unbind();
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
	jQuery(".comment-submit").unbind();
	jQuery(".comment-submit").click(function() {
    jQuery(this).hide();
		jQuery(this).parents('.comment-form-wrapper').siblings('.actor-icon').hide();
		jQuery(this).siblings('textarea').hide();
		jQuery(this).parent().append('<p class="comment-loading"><img src="/images/spinner.gif" alt="loading..." /> ' + ADD_COMMENT_MESSAGE + '</p>');
		var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action'), form.serialize() + '&format=json',
      function(data){
        var json = eval('(' + data + ')');
        if(!json.success){
          jQuery.jGrowl.info(json.message);
        } else {
					jQuery('.comment-loading').remove();
					jQuery('.activity-has-comments').find('textarea').show();
					var comment_box = jQuery('#comment_activity_' + json.parent_id);
					comment_box.before(json.html);
					comment_box.removeClass('activity-no-comments');
					comment_box.addClass('activity-has-comments');
					comment_box.find('textarea').show();
					apply_activity_ajax_methods();
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

function apply_comment_hover(){
	jQuery('.activity-comment').hover(
     function () { jQuery(this).addClass('comment-hover'); }, 
     function () { jQuery(this).removeClass('comment-hover'); } );
}