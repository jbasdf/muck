function formElement() {
	return document.insert_file;
}

tinyMCEPopup.requireLangPack();

var templates = {
	"window.open" : "window.open('${url}','${target}','${options}')"
};

function preinit() {
	var url;
	if (url = tinyMCEPopup.getParam("external_link_list_url"))
		document.write('<script language="javascript" type="text/javascript" src="' + tinyMCEPopup.editor.documentBaseURI.toAbsolute(url) + '"></script>');
}

function init() {
	tinyMCEPopup.resizeToInnerSize();

	var formObj = formElement();
	var inst = tinyMCEPopup.editor;

	if(inst.selection.getContent().length > 0){
		formObj.title.value = inst.selection.getContent();
	}

	// Resize some elements
	if (isVisible('hrefbrowser'))
		document.getElementById('href').style.width = '260px';

}

function checkPrefix(n) {
	if (n.value && Validator.isEmail(n) && !/^\s*mailto:/i.test(n.value) && confirm(tinyMCEPopup.getLang('advlink_dlg.is_email')))
		n.value = 'mailto:' + n.value;

	if (/^\s*www./i.test(n.value) && confirm(tinyMCEPopup.getLang('advlink_dlg.is_external')))
		n.value = 'http://' + n.value;
}

function setAttrib(elm, attrib, value) {
	var formObj = formElement();
	var valueElm = formObj.elements[attrib.toLowerCase()];
	var dom = tinyMCEPopup.editor.dom;

	if (typeof(value) == "undefined" || value == null) {
		value = "";

		if (valueElm)
			value = valueElm.value;
	}

	// Clean up the style
	if (attrib == 'style')
		value = dom.serializeStyle(dom.parseStyle(value));

	dom.setAttrib(elm, attrib, value);
}

function insertAction() {
	var inst = tinyMCEPopup.editor;
	var elm, elementArray, i;
	var formObj = formElement();
	
	if(inst.selection.getContent().length <= 0){
		inst.selection.setContent('<a href="#mce_temp_url#">' + formObj.title.value + '</a>');
	}
	
	elm = inst.selection.getNode();
	checkPrefix(formObj.href);

	elm = inst.dom.getParent(elm, "A");

	// Remove element if there is no href
	if (!formObj.href.value) {
		tinyMCEPopup.execCommand("mceBeginUndoLevel");
		i = inst.selection.getBookmark();
		inst.dom.remove(elm, 1);
		inst.selection.moveToBookmark(i);
		tinyMCEPopup.execCommand("mceEndUndoLevel");
		tinyMCEPopup.close();
		return;
	}

	tinyMCEPopup.execCommand("mceBeginUndoLevel");

	// Create new anchor elements
	if (elm == null) {
		
		tinyMCEPopup.execCommand("CreateLink", false, "#mce_temp_url#", {skip_undo : 1});

		elementArray = tinymce.grep(inst.dom.select("a"), function(n) {return inst.dom.getAttrib(n, 'href') == '#mce_temp_url#';});
		for (i=0; i<elementArray.length; i++)
			setAllAttribs(elm = elementArray[i]);
	} else
		setAllAttribs(elm);

	// Don't move caret if selection was image
	if (elm.childNodes.length != 1 || elm.firstChild.nodeName != 'IMG') {
		inst.focus();
		inst.selection.select(elm);
		inst.selection.collapse(0);
		tinyMCEPopup.storeSelection();
	}

	tinyMCEPopup.execCommand("mceEndUndoLevel");
	tinyMCEPopup.close();
}

function setAllAttribs(elm) {
	var formObj = formElement();
	var href = formObj.href.value;
	var target = getSelectValue(formObj, 'targetlist');

	setAttrib(elm, 'href', href);
	setAttrib(elm, 'title');
	setAttrib(elm, 'target', target == '_self' ? '' : target);
	setAttrib(elm, 'id');
	setAttrib(elm, 'style');
	setAttrib(elm, 'class', getSelectValue(formObj, 'classlist'));
	setAttrib(elm, 'rel');
	setAttrib(elm, 'rev');
	setAttrib(elm, 'charset');
	setAttrib(elm, 'hreflang');
	setAttrib(elm, 'dir');
	setAttrib(elm, 'lang');
	setAttrib(elm, 'tabindex');
	setAttrib(elm, 'accesskey');
	setAttrib(elm, 'type');

	// Refresh in old MSIE
	if (tinyMCE.isMSIE5)
		elm.outerHTML = elm.outerHTML;
}

function getSelectValue(form_obj, field_name) {
	var elm = form_obj.elements[field_name];

	if (!elm || elm.options == null || elm.selectedIndex == -1)
		return "";

	return elm.options[elm.selectedIndex].value;
}

// While loading
preinit();
tinyMCEPopup.onInit.add(init);
