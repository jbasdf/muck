GlobalConfig.advanced_mce_options = {
  :theme => 'advanced',
  :content_css => GlobalConfig.content_css,
  :body_id => 'content',
  :mode => "textareas",
  :height => 650,
  :width => 830,
  :browsers => %w{msie gecko safari},
  :theme_advanced_layout_manager => "SimpleLayout",
  :theme_advanced_statusbar_location => "bottom",
  :theme_advanced_toolbar_location => "top",
  :theme_advanced_toolbar_align => "left",
  :theme_advanced_resizing => true,
  :relative_urls => false,
  :convert_urls => false,
  :cleanup => true,
  :cleanup_on_startup => true,  
  :convert_fonts_to_spans => true,
  :theme_advanced_resize_horizontal => false,
  :theme_advanced_buttons1 => %w{save cancel print preview separator
                                search replace separator
                                cut copy paste pastetext pasteword selectall undo redo separator
                                bold italic underline strikethrough separator 
                                justifyleft justifycenter justifyright indent outdent separator 
                                bullist numlist separator 
                                link unlink image file media anchor separator  
                                template visualaid separator
                                fullscreen code},
  :theme_advanced_buttons2 => %w{styleprops styleselect separator
                                 formatselect fontselect fontsizeselect separator 
                                 forecolor backcolor separator
                                 tablecontrols separator
                                 sub sup charmap },
  :theme_advanced_buttons3 => %w{}, #bramus_cssextras_classes bramus_cssextras_ids
  #:theme_advanced_buttons3 => %w{cleanup code insertdate inserttime removeformat insertlayer},
  :plugins => %w{ paste media preview inlinepopups safari save searchreplace table style template fullscreen print autosave muckimage mucklink},
  # codehighlighting
  # spellchecker,pagebreak,layer,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,
  # contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template
  # bramus_cssextras
  :editor_deselector => "mceNoEditor",
  :editor_selector => 'mceEditor',
  :remove_script_host => true,
  :extended_valid_elements => "img[class|src|flashvars|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name|obj|param|embed|scale|wmode|salign|style],embed[src|quality|scale|salign|wmode|bgcolor|width|height|name|align|type|pluginspage|flashvars],span[class|style],code[class],object[align<bottom?left?middle?right?top|archive|border|class|classid|codebase|codetype|data|declare|dir<ltr?rtl|height|hspace|id|lang|name|style|tabindex|title|type|usemap|vspace|width],iframe[id|class|title|style|align|frameborder|height|longdesc|marginheight|marginwidth|name|scrolling|src|width]",
  :template_cdate_classes => "cdate creationdate",
  :template_mdate_classes => "mdate modifieddate",
  :template_selected_content_classes => "selcontent",
  :template_cdate_format => "%m/%d/%Y : %H:%M:%S",
  :template_mdate_format => "%m/%d/%Y : %H:%M:%S",
  :save_onsavecallback => 'save_page',
  :accessibility_warnings => false
  }
   
GlobalConfig.simple_mce_options = {
  :theme => 'advanced',
  :content_css => GlobalConfig.content_css,
  :body_id => 'content',
  :browsers => %w{msie gecko safari},
  :cleanup_on_startup => true,
  :convert_fonts_to_spans => true,
  :theme_advanced_resizing => true, 
  :theme_advanced_toolbar_location => "top",  
  :theme_advanced_statusbar_location => "bottom", 
  :editor_deselector => "mceNoEditor",
  :theme_advanced_resize_horizontal => false,  
  :theme_advanced_buttons1 => %w{bold italic underline separator bullist numlist separator link unlink},
  :theme_advanced_buttons2 => [],
  :theme_advanced_buttons3 => [],
  :plugins => %w{inlinepopups safari}
  }

GlobalConfig.raw_mce_options = 'template_templates : [
  {
    title : "A page",
    src : "/javascripts/tiny_mce/templates/bio.htm",
    description : "Easily add a new biography for a team member."
  },
  {
    title : "Country Page",
    src : "/javascripts/tiny_mce/templates/country.htm",
    description : "Add a new country page."
  }
]'
