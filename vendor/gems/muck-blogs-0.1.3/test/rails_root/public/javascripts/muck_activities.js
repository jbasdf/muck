jQuery(document).ready(function() {
	apply_blog_methods();
});

function apply_blog_methods(){
	setup_blog_submit();
	hide_blog_boxes();
	apply_blog_hover();
	apply_activity_hover();
	jQuery('.activity-no-blogs').hide();
	
	jQuery('.activity-has-blogs').find('textarea').click(function(){
		show_blog_box(this);
	});
	jQuery('.activity-has-blogs').find('textarea').blur(function(){
		textarea = jQuery(this);
		if (textarea.val() == ''){
			hide_blog_boxes();
		}
	});
	
	jQuery(".make-blog").unbind();
	jQuery('.make-blog').click(function(){
		var id = this.id.replace('make_blog_activity_', '');
		var blog_box = jQuery('#blog_activity_' + id);
		blog_box.find('textarea').removeClass('min');
		blog_box.find('textarea').addClass('max');
		blog_box.show();
		blog_box.find('textarea').get(0).focus();
		blog_box.find('textarea').blur(function(){
			if (jQuery(this).val() == ''){
				jQuery(this).closest('.activity-blog').hide();
			}
		});
		return false;
	});
}

function setup_blog_submit(){
	jQuery(".blog-submit").unbind();
	jQuery(".blog-submit").click(function() {
    jQuery(this).hide();
		jQuery(this).parents('.blog-form-wrapper').siblings('.actor-icon').hide();
		jQuery(this).siblings('textarea').hide();
		jQuery(this).parent().append('<p class="blog-loading"><img src="/images/spinner.gif" alt="loading..." /> ' + ADD_COMMENT_MESSAGE + '</p>');
		var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action'), form.serialize() + '&format=json',
      function(data){
        var json = eval('(' + data + ')');
        if(!json.success){
          jQuery.jGrowl.info(json.message);
        } else {
					jQuery('.blog-loading').remove();
					jQuery('.activity-has-blogs').find('textarea').show();
					var blog_box = jQuery('#blog_activity_' + json.parent_id);
					blog_box.before(json.html);
					blog_box.removeClass('activity-no-blogs');
					blog_box.addClass('activity-has-blogs');
					blog_box.find('textarea').show();
					apply_blog_methods();
				}
      });
    return false;
  });
}

function hide_blog_boxes(){
	jQuery('.activity-has-blogs').children('.actor-icon').hide();
	jQuery('.activity-has-blogs').find('.button').hide();
	jQuery('.activity-has-blogs').find('textarea').val(COMMENT_PROMPT);
	jQuery('.activity-has-blogs').find('textarea').addClass('min');
}

function show_blog_box(obj){
	textarea = jQuery(obj);
	textarea.addClass('max');
	textarea.removeClass('min');
	textarea.closest('.blog-form-wrapper').siblings('.actor-icon').show();
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

function apply_blog_hover(){
	jQuery('.activity-blog').hover(
     function () { jQuery(this).addClass('blog-hover'); }, 
     function () { jQuery(this).removeClass('blog-hover'); } );
}