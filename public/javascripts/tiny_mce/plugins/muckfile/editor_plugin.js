/**
 * Modified version of advfile
 * @author Tatamae
 * @copyright Copyright © 2009, Tatemae.
 */
(function() {
	tinymce.create('tinymce.plugins.AdvancedFileTooPlugin', {
		init : function(ed, url) {
			// Register commands
			ed.addCommand('mceAdvFileToo', function() {
				var e = ed.selection.getNode();
				// Internal file object like a flash placeholder
				if (ed.dom.getAttrib(e, 'class').indexOf('mceItem') != -1)
					return;
				ed.windowManager.open({
					file : jQuery('#tiny_mce_files_path').val(),
					width : parseInt(jQuery('#tiny_mce_files_width').val()) + parseInt(ed.getLang('muckfile.delta_width', 0)),
					height : parseInt(jQuery('#tiny_mce_files_height').val()) + parseInt(ed.getLang('muckfile.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});
			// Register button
			ed.addButton('file', {
				title : 'Upload Files',
				cmd : 'mceAdvFileToo',
				image : '/images/tinymce/upload.gif'
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
	tinymce.PluginManager.add('muckfile', tinymce.plugins.AdvancedFileTooPlugin);
})();