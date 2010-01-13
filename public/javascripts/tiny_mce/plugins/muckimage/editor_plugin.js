/**
 * Modified version of advimage
 * @author Tatamae
 * @copyright Copyright © 2009, Tatemae.
 */
(function() {
	tinymce.create('tinymce.plugins.AdvancedImageTooPlugin', {
		init : function(ed, url) {
			// Register commands
			ed.addCommand('mceAdvImageToo', function() {
				var e = ed.selection.getNode();
				// Internal image object like a flash placeholder
				if (ed.dom.getAttrib(e, 'class').indexOf('mceItem') != -1)
					return;
				ed.windowManager.open({
					file : jQuery('#tiny_mce_images_path').val(),
					width : parseInt(jQuery('#tiny_mce_images_width').val()) + parseInt(ed.getLang('muckfile.delta_width', 0)),
					height : parseInt(jQuery('#tiny_mce_images_height').val()) + parseInt(ed.getLang('muckfile.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});
			// Register buttons
			ed.addButton('image', {
				title : 'Upload Images',
				cmd : 'mceAdvImageToo'
			});
		},
		getInfo : function() {
			return {
				longname : 'Advanced file',
				author : 'Tatemae',
				authorurl : 'http://Tatemae.com',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});
	// Register plugin
	tinymce.PluginManager.add('muckimage', tinymce.plugins.AdvancedImageTooPlugin);
})();