function apply_show_entry_content(){
  jQuery('.combined-feed-list .feed-item .feed-title').hover(
    function () {
      jQuery(this).next('.combined-feed-list .feed-item .feed-content').show();
    }, 
    function () {
      jQuery(this).next('.combined-feed-list .feed-item .feed-content').hide();
    }
  );
  jQuery('.combined-feed-list .feed-item .feed-content').hover(
    function () {
      jQuery(this).show();
    }, 
    function () {
      jQuery(this).hide();
    }
  );
}

function show_tool(tool) {
  jQuery('.tool').hide();
  jQuery("#content_iframe").width('75%');
  jQuery('#' + tool + '_tool').show();
  maximize_space();
  return false;
}
function maximize_space() {
  var container = jQuery(".tools_container");
  var spacer = jQuery('#comments_tools_close_wrapper').height() + 5;
  container.height(jQuery(window).height() - (jQuery('#toolbar').height() + spacer));
}
function setup_entry_comment_submit(){
	jQuery(".entry-comment-submit").click(function() {
		jQuery(this).siblings('textarea').hide();
		jQuery(".entry-comment-submit").hide();
		jQuery(this).parent().append('<p class="entry-comment-loading"><img src="/images/spinner.gif" alt="loading..." /> ' + ADD_COMMENT_MESSAGE + '</p>');
		var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action'), form.serialize() + '&format=json',
      function(data){
        var json = eval('(' + data + ')');
        if(!json.success){
          jQuery.jGrowl.info(json.message);
        } else {
					jQuery('.entry-comment-loading').remove();
					jQuery('#comments_tool').find('textarea').show();
					jQuery('#comments_tool').find('textarea').val('');
					jQuery(".entry-comment-submit").show();
					jQuery("#comments_container").animate({ scrollTop: jQuery("#comments_tool").attr("scrollHeight") }, 3000);
					var contents = jQuery(json.html)
					contents.hide();
					jQuery('#comments_wrapper').append(contents);
					contents.fadeIn("slow");
					apply_frame_comment_hover();
				}
      });
    return false;
  });
}
function apply_frame_comment_hover(){
	jQuery('.comment_holder').hover(
     function () { jQuery(this).addClass('comment-hover'); }, 
     function () { jQuery(this).removeClass('comment-hover'); } );
}
function setup_share_submit(){
  jQuery('#share_submit_share_new').click(function() {
		jQuery(this).parent().append('<p class="share-loading"><img src="/images/spinner.gif" alt="loading..." /> ' + ADD_SHARE_MESSAGE + '</p>');
		jQuery('#share_submit_share_new').hide();
		var form = jQuery(this).parents('form');
    jQuery.post(form.attr('action'), form.serialize() + '&format=json',
      function(data){
        var json = eval('(' + data + ')');
        jQuery('.share-loading').remove();
        jQuery('#share_submit_share_new').show();
        if(!json.success){
          jQuery.jGrowl.info(json.message);
        } else {
          jQuery.jGrowl.info(json.message);
        }
      });
    return false;
  });
}

jQuery(document).ready(function() {
  jQuery("#content_iframe").load(maximize_iframe_height);
  jQuery(window).bind('resize', function() {
    maximize_iframe_height();
  });
});

function maximize_iframe_height() {
  var frame = jQuery("#content_iframe");
  frame.height(jQuery(window).height() - jQuery('#toolbar').height());
}