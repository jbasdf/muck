// ==UserScript==
// @name           RecommenderExtension
// @namespace      folksemantic.com
// @description    Folksemantic Recommender GM Script - Recommends resources to a user based upon their current url.
// @include        *
// ==/UserScript==

// The drag functionality was unabashedly stollen from the RSS Panel script: 
// http://www.xs4all.nl/~jlpoutre/BoT/Javascript/RSSpanel

var Drag = function(){ this.init.apply( this, arguments ); };

Drag.fixE = function( e )
{
  if( typeof e == 'undefined' ) e = window.event;
  if( typeof e.layerX == 'undefined' ) e.layerX = e.offsetX;
  if( typeof e.layerY == 'undefined' ) e.layerY = e.offsetY;
  return e;
};

Drag.prototype.init = function( handle, dragdiv )
{
  this.div = dragdiv || handle;
  this.handle = handle;
  if( isNaN(parseInt(this.div.style.left)) ) this.div.style.left  = '0px';
  if( isNaN(parseInt(this.div.style.top)) ) this.div.style.top = '0px';
  this.onDragStart = function(){};
  this.onDragEnd = function(){};
  this.onDrag = function(){};
  this.onClick = function(){};
  this.mouseDown = addEventHandler(this.handle, 'mousedown', this.start, this);
};

Drag.prototype.start = function( e )
{
  e = Drag.fixE(e);

  this.started = new Date();
  var y = this.startY = parseInt(this.div.style.top);
  var x = this.startX = parseInt(this.div.style.left);
  this.onDragStart(x, y);
  this.lastMouseX = e.clientX;
  this.lastMouseY = e.clientY;
  this.documentMove = addEventHandler(document, 'mousemove', this.drag, this);
  this.documentStop = addEventHandler(document, 'mouseup', this.end, this);
  if (e.preventDefault) e.preventDefault();
  return false;
};

Drag.prototype.drag = function( e )
{
  e = Drag.fixE(e);
  var ey = e.clientY;
  var ex = e.clientX;
  var y = parseInt(this.div.style.top);
  var x = parseInt(this.div.style.left);
  var nx = ex + x - this.lastMouseX;
  var ny = ey + y - this.lastMouseY;
  this.div.style.left	= nx + 'px';
  this.div.style.top	= ny + 'px';
  this.lastMouseX	= ex;
  this.lastMouseY	= ey;
  this.onDrag(nx, ny);
  if (e.preventDefault) e.preventDefault();
  return false;
};

Drag.prototype.end = function()
{
  removeEventHandler( document, 'mousemove', this.documentMove );
  removeEventHandler( document, 'mouseup', this.documentStop );
  var time = (new Date()) - this.started;
  var x = parseInt(this.div.style.left),  dx = x - this.startX;
  var y = parseInt(this.div.style.top), dy = y - this.startY;
  this.onDragEnd( x, y, dx, dy, time );
  if( (dx*dx + dy*dy) < (4*4) && time < 1e3 )
    this.onClick( x, y, dx, dy, time );
};

function removeEventHandler( target, eventName, eventHandler )
{
  if( target.addEventListener )
    target.removeEventListener( eventName, eventHandler, true );
  else if( target.attachEvent )
    target.detachEvent( 'on' + eventName, eventHandler );
}

function addEventHandler( target, eventName, eventHandler, scope )
{
  var f = scope ? function(){ eventHandler.apply( scope, arguments ); } : eventHandler;
  if( target.addEventListener )
    target.addEventListener( eventName, f, true );
  else if( target.attachEvent )
    target.attachEvent( 'on' + eventName, f );
  return f;
}

function dom_setStyle(elt, str) 
{
    elt.setAttribute("style", str);
	// for MSIE:
	if (elt.style.setAttribute) {
		elt.style.setAttribute("cssText", str, 0);
		// positioning for MSIE:
		if (elt.style.position == "fixed") {
			elt.style.position = "absolute";
		}
	}
}

function special_website_url(url)
{
    // NEEDS
    if (url.indexOf("http://www.needs.org/") == 0)
    {
        bNeeds = true;
        if (url.length > 167 && url.indexOf("http://www.needs.org/needs/public/search/search_results/learning_resource/summary/index.jhtml") == 0)
        {
            bNeedsRecord = true;
            nHook = url.indexOf("?");
            if (nHook != -1)
            {
                url = "http://www.needs.org/needs/" + url.substring(nHook, url.length);
            }
        }
    }
    // eduCommons websites
    else if (document.getElementById("portlet-eduCommonsNavigation"))
    {
        bSpecialSite = true;
        var nEnd = url.indexOf("/",20);
        if (nEnd != -1)
        {
            nEnd = url.indexOf("/",nEnd + 1);
            if (nEnd != -1)
            {
                url = url.substr(0,nEnd);
            }
        }
    }
    // MIT
    else if (url.indexOf("http://ocw.mit.edu/") == 0)
    {
        bSpecialSite = true;
        bMIT = true;
        var nEnd = url.indexOf("/",20);
        if (nEnd != -1)
        {
            nEnd = url.indexOf("/",nEnd + 1);
            if (nEnd != -1)
            {
                nEnd = url.indexOf("/",nEnd + 1);
                if (nEnd != -1)
                {
                    url = url.substr(0,nEnd + 1) + "CourseHome/index.htm";
                }
            }
        }
    }
    return encodeURI(url);
}

function getElementByClassName(sTagName, sClassName)
{
    var aTags = document.getElementsByTagName(sTagName);
    for (var nTag = 0; nTag < aTags.length; nTag++)
    {
         if (sClassName == aTags[nTag].className) return aTags[nTag];
    }
    return null;
}

function identifySquatParent()
{
    // educommons
    squatParent = document.getElementById("portlet-eduCommonsNavigation");
    if (squatParent)
    {
        squatSibling = squatParent.lastChild;
        divTags = squatParent.getElementsByTagName("div");
        lastDivTag = divTags[divTags.length - 1];
        sTopMargin = (lastDivTag.className == "currentSelection") ? "6px" : "0px";
        sLeftMargin = "0px";
        sRightMargin = "0px";
    }
    else
    {
        // MIT
        squatParent = getElementByClassName("div", "left-nav");
        if (bMIT && squatParent)
        {
            ulTags = squatParent.getElementsByTagName("ul");
            if (ulTags)
            { 
                ulTag = ulTags[0];
                if (ulTag) ulTag.style.margin = "0px 0px 6px;";
            }
            squatSibling = squatParent.lastChild;
            sLeftMargin = "6px";
            sRightMargin = "6px";
        }
        // everything else
        else
        {
           if (body.parentNode)
           {
               squatParent = body.parentNode;
               squatSibling = body.nextSibling;
           }
        }    
    }
}
function blacklistedDomain()
{
    return (sUrlToGetRecsFor.indexOf('folksemantic') != -1);
} 
        
// get a hold of the body tag
var squatParent = null;
var squatSibling = null;
var sTopMargin = "3px";
var sRightMargin = "3px";
var sBottomMargin = "40px";
var sLeftMargin = "3px";
var bSpecialSite = false;
var bNeeds = false;
var bMIT = false;
var bNeedsRecord = false;
var sUrlToGetRecsFor = null;

var bodyTags = document.getElementsByTagName('body');
var body = null;
sUrlToGetRecsFor = special_website_url(new String(window.location));
if (bodyTags && bodyTags.length > 0 && !blacklistedDomain())
{
body = bodyTags[0];

// figure out where to insert the squatter
if ((bNeeds == true && bNeedsRecord == true) || bNeeds == false) identifySquatParent(); 

// request the recommendations for this page
if (squatParent != null)
{
var sBaseUrl = 'http://www.folksemantic.com/';
//var sBaseUrl = 'http://localhost:3000/';
var sServiceUrl = sBaseUrl + 'recommendations.xml?u=';
var sShowDocUrl = sBaseUrl + 'resources/';

GM_xmlhttpRequest(
{
    method: 'GET',
    url: sServiceUrl + sUrlToGetRecsFor,
    headers: {'User-agent': 'Mozilla/4.0 (compatible) Greasemonkey/0.3',},
    
    // when the thing loads
    onload: function(responseDetails) 
    {
        // parse the recommendations xml
        var parser = new DOMParser();
        var dom = parser.parseFromString(responseDetails.responseText, "application/xml");
        var root = dom.getElementsByTagName('recommendations')[0];
        var recommendations = dom.getElementsByTagName('recommendation');
        
        // if any recommendations were provided
        if (recommendations.length > 0)
        {
			var sTitle = root.getAttribute("title");
			var sDirectLinkText = root.getAttribute("direct_link_text");
            var sRecTitle = '<div id="recommendertop" style="margin: 3px 3px 6px 3px; padding: 0px; color: #556664; font-weight: bold;">' + sTitle + '</div>';
            var sRecListDivStart = '<div id="recommenderlist" style="margin: 3px; padding: 0px;">';
            var sRecListDivEnd = '</div>';
            var sListStart = '<ul style="margin-left: 0px; padding-left: 0px; list-style-type: none;">';
            var sListEnd = '</ul>';
			var sDocID = root.getAttribute("document_id");
			var sMorePrompt = root.getAttribute("more_prompt");
            var sMoreLink = '<div class="recommender_more_link" style="margin: 3px; padding: 0px;" align="center"><a href="' + sShowDocUrl + sDocID + '" style="color:#3987DC !important; text-decoration:none !important; ">' + sMorePrompt + '</a></div>';
            var sRecList = bSpecialSite == true ? '' : sListStart;
            for (var i = 0; i < recommendations.length; i++) 
            {
                // get info for the recommendation
                rec_title = recommendations[i].getElementsByTagName('title')[0].textContent;
				link_uri = recommendations[i].getElementsByTagName('link')[0].textContent;
				collection = recommendations[i].getElementsByTagName('collection')[0].textContent;
				has_direct_link = recommendations[i].getElementsByTagName('has_direct_link')[0];
                rec_link = link_uri;
                rec_description = recommendations[i].getElementsByTagName('description')[0].textContent;
                rec_tag = '<a href="' + rec_link + '" style="color:#3987DC !important; text-decoration:none !important; " target="_top">' + rec_title + ' (' + collection + ')</a>';
                direct_link_tag = has_direct_link ? ' <a href="' + rec_link + '&target=direct_link" style="color:#556664 !important; text-decoration:none !important; " target="_top">' + sDirectLinkText + '</a>' : "";
                
                // our lists are different in educommons and on MIT's websites
                if (bSpecialSite == true)
	       		{
                    sRecList += "<p style='font-size:12px;'>";
	       			sRecList += rec_tag + direct_link_tag;
                    sRecList += "</p>";
                }
                // default list styles    
           		else
                {
           			sRecList += '<li style="margin-left: 0px; padding: 3px; list-style-type: none; font-size: 12px; ';
        			if (i%2 == 0) sRecList += 'background-color:#E6E6E6;';
	       			sRecList += '">';
	       			sRecList += rec_tag + direct_link_tag;
    				sRecList += '</li>'; 
                }
            }
            if (bSpecialSite == false) sRecList += sListEnd;
            
            // create the recommender div
            var recommendersquat = document.createElement('div');
            
            // set its content
            recommendersquat.innerHTML = sRecTitle + sRecListDivStart + sRecList + sRecListDivEnd + sMoreLink;
            
            // insert the recommender div as a child of the body tag
            squatParent.insertBefore(recommendersquat, squatSibling);
	
            // we treat educommons and mit sites differently 
            if (bSpecialSite == true)
            {
            	// position the squatter
             	recommendersquat.setAttribute("style", 'margin: ' + sTopMargin + ' ' + sRightMargin + ' ' + sBottomMargin + ' ' + sLeftMargin + '; padding: 3px; border:1px solid #000000; background-color:#FFFFFF; z-index:999; font-size: 12px; font-family:Arial, Helvetica, sans-serif !important; ');
            }
            // default positioning and styling
            else
            {
                // calculate the position for the recommender div
            	var squatterWidth= 250;
            	var addScrollWidth;
            	if (document.documentElement.scrollHeight > document.documentElement.clientHeight)
            		{var addScrollWidth = 20;}
            	else
            		{var addScrollWidth = 5;}
            	var rightAligned = window.innerWidth - squatterWidth - addScrollWidth;
        	
            	// get a hold of the title div 
            	var recommendertop = document.getElementById('recommendertop');
        	
            	// position the squatter
                recommendersquat.setAttribute("style", 'margin:0px; font-size: 12px; font-family:Arial, Helvetica, sans-serif !important; border:1px solid #000000; width:' + squatterWidth + 'px; position:absolute; left:' + rightAligned + 'px; top:0px; background-color:#FFFFFF; z-index:999;');

            	// make the div draggable
            	recommendersquat.drag = new Drag(recommendertop, recommendersquat);
        	
            	// insert a close box into the div title
            	var close = window.document.createElement("div");
    	     	dom_setStyle(close,
                   "margin:0px 3px; position:absolute; top:3px; right:3px; width:10px; height:10px; border:1px solid #fff; line-height:8px; text-align:center; cursor:pointer; color:#3987DC; font-size:15px; background-color:#fff; font-weight:bold; z-index:999;");
        		    close.setAttribute("title","Click to close panel");
          		close.addEventListener('click', function() { this.parentNode.style.display = "none"; }, true);
    		    close.appendChild(window.document.createTextNode("x"));
    		    recommendersquat.appendChild(close);
            }
        }		
    }
}
);
}
}