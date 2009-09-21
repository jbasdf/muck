// ==UserScript==
// @name           RecommenderExtension
// @namespace      folksemantic.com
// @description    Folksemantic Recommender GM Script - Recommends resources to a user based upon their current url.
// @include        *
// ==/UserScript==

var sUrlToGetRecsFor = new String(window.location);
if (self != top && !folksemanticFrames(sUrlToGetRecsFor)) return;

var Drag = function() {
    this.init.apply(this, arguments);
};

Drag.fixE = function(e) {
    if (typeof e == 'undefined') e = window.event;
    if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
    if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
    return e;
};

Drag.prototype.init = function(handle, dragdiv) {
    this.div = dragdiv || handle;
    this.handle = handle;
    if (isNaN(parseInt(this.div.style.left))) this.div.style.left = '0px';
    if (isNaN(parseInt(this.div.style.top))) this.div.style.top = '0px';
    this.onDragStart = function() {};
    this.onDragEnd = function() {};
    this.onDrag = function() {};
    this.onClick = function() {};
    this.mouseDown = addEventHandler(this.handle, 'mousedown', this.start, this);
};

Drag.prototype.start = function(e) {
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

Drag.prototype.drag = function(e) {
    e = Drag.fixE(e);
    var ey = e.clientY;
    var ex = e.clientX;
    var y = parseInt(this.div.style.top);
    var x = parseInt(this.div.style.left);
    var nx = ex + x - this.lastMouseX;
    var ny = ey + y - this.lastMouseY;
    this.div.style.left = nx + 'px';
    this.div.style.top = ny + 'px';
    this.lastMouseX = ex;
    this.lastMouseY = ey;
    this.onDrag(nx, ny);
    if (e.preventDefault) e.preventDefault();
    return false;
};

Drag.prototype.end = function() {
    removeEventHandler(document, 'mousemove', this.documentMove);
    removeEventHandler(document, 'mouseup', this.documentStop);
    var time = (new Date()) - this.started;
    var x = parseInt(this.div.style.left),  dx = x - this.startX;
    var y = parseInt(this.div.style.top), dy = y - this.startY;
    this.onDragEnd(x, y, dx, dy, time);
    if ((dx * dx + dy * dy) < (4 * 4) && time < 1e3)
        this.onClick(x, y, dx, dy, time);
};

function removeEventHandler(target, eventName, eventHandler) {
    if (target.addEventListener)
        target.removeEventListener(eventName, eventHandler, true);
    else if (target.attachEvent)
        target.detachEvent('on' + eventName, eventHandler);
}

function addEventHandler(target, eventName, eventHandler, scope) {
    var f = scope ? function() {
        eventHandler.apply(scope, arguments);
    } : eventHandler;
    if (target.addEventListener)
        target.addEventListener(eventName, f, true);
    else if (target.attachEvent)
        target.attachEvent('on' + eventName, f);
    return f;
}

function dom_setStyle(elt, str) {
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

function special_website_url(url) {
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
        var nEnd = url.indexOf("/", 20);
        if (nEnd != -1)
        {
            nEnd = url.indexOf("/", nEnd + 1);
            if (nEnd != -1)
            {
                url = url.substr(0, nEnd);
            }
        }
    }
    // MIT
    else if (url.indexOf("http://ocw.mit.edu/") == 0)
        {
            bSpecialSite = true;
            bMIT = true;
            var nEnd = url.indexOf("/", 20);
            if (nEnd != -1)
            {
                nEnd = url.indexOf("/", nEnd + 1);
                if (nEnd != -1)
                {
                    nEnd = url.indexOf("/", nEnd + 1);
                    if (nEnd != -1)
                    {
                        url = url.substr(0, nEnd + 1) + "CourseHome/index.htm";
                    }
                }
            }
        }
    return encodeURI(url);
}

function getElementByClassName(sTagName, sClassName) {
    var aTags = document.getElementsByTagName(sTagName);
    for (var nTag = 0; nTag < aTags.length; nTag++)
    {
        if (sClassName == aTags[nTag].className) return aTags[nTag];
    }
    return null;
}

function identifySquatParent() {
    // educommons
    squatParent = document.getElementById("portlet-eduCommonsNavigation");
    if (squatParent) {
        squatSibling = squatParent.lastChild;
        divTags = squatParent.getElementsByTagName("div");
        lastDivTag = divTags[divTags.length - 1];
        sTopMargin = (lastDivTag.className == "currentSelection") ? "6px" : "0px";
        sLeftMargin = "0px";
        sRightMargin = "0px";
    } else {
        // MIT
        squatParent = getElementByClassName("div", "left-nav");
        if (bMIT && squatParent) {
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
        else {
            if (body.parentNode) {
                squatParent = body.parentNode;
                squatSibling = body.nextSibling;
            }
        }
    }
}

String.prototype.startsWith = function(str)
{
    return (this.match("^" + str) == str)
}

function demoDomain(sUrl) {
    for (nDomain = 0; nDomain < demoDomains.length; nDomain++) {
        if (sUrl.startsWith(demoDomains[nDomain])) return true;
    }
    return folksemanticFrames(sUrl);
}
function blacklistedDomain(sUrl) {
    for (nDomain = 0; nDomain < blacklistedDomains.length; nDomain++) {
        if (sUrl.startsWith(blacklistedDomains[nDomain])) return true;
    }
    return false;
}
function userRequest(sUrl) {
    return (sUrl.indexOf("rtr=true") != -1);
}
function folksemanticFrames(sUrl) {
    return (sUrl.indexOf("show_recs=true") != -1);
}

function recList(recommendations, sDirectLinkText) {
    var sRecListDivStart = '<div id="recommenderlist" style="margin: 3px; padding: 0px;">';
    var sRecListDivEnd = '</div>';
    var sListStart = '<ul style="margin: 0px; padding: 0px; list-style-type: none;">';
    var sListEnd = '</ul>';
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
            if (i % 2 == 0) sRecList += 'background-color:#E6E6E6;';
            sRecList += '">';
            sRecList += rec_tag + direct_link_tag;
            sRecList += '</li>';
        }
    }
    if (bSpecialSite == false) sRecList += sListEnd;
    return sRecList;
}

function morePrompt(root) {
    var sDocID = root.getAttribute("document_id");
    var sMorePrompt = root.getAttribute("more_prompt");
    return sDocID == '' ? '' : '<div class="recommender_more_link" style="margin: 3px; padding: 0px;" align="center"><a href="' + sShowDocUrl + sDocID + '" style="color:#3987DC !important; text-decoration:none !important; ">' + sMorePrompt + '</a></div>';
}

function positionSquatter(recommendersquat, bDraggable) {
    // we treat educommons and mit sites differently
    if (bSpecialSite == true)
    {
        // position the squatter
        recommendersquat.setAttribute("style", 'margin: ' + sTopMargin + ' ' + sRightMargin + ' ' + sBottomMargin + ' ' + sLeftMargin + '; padding: 3px; border:1px solid #000000; background-color:#FFFFFF; z-index:999; font-size: 12px; font-family:Arial, Helvetica, sans-serif !important; ');
    }
    // default positioning and styling
    else {
        // calculate the position for the recommender div
        var squatterWidth = 250;
        var scrollWidth = 5;
        if (document.documentElement.scrollHeight > document.documentElement.clientHeight)
            scrollWidth = 20;
        var rightAligned = window.innerWidth - squatterWidth - scrollWidth;

        // get a hold of the title div
        var recommendertop = document.getElementById('recommendertop');

        // position the squatter
        recommendersquat.setAttribute("style", 'margin:0px; font-size: 12px; font-family:Arial, Helvetica, sans-serif !important; border:1px solid #000; width:' + squatterWidth + 'px; position:absolute; left:' + rightAligned + 'px; top:2px; background-color:#FFF; z-index:999;');

        // make the div draggable
        if (bDraggable) recommendersquat.drag = new Drag(recommendertop, recommendersquat);

        // insert a close box into the div title
        var close = window.document.createElement("div");
        dom_setStyle(close,
                "margin:0; position:absolute; top:3px; right:3px; font-family:arial,sans-serif;padding:1px; width:10px; border:1px solid #BBBBBB; text-align:center; cursor:pointer; color:#BBB; font-size:11px; background-color:#fff; font-weight:bold; z-index:999;");
        close.setAttribute("title", "Click to close panel");
        close.addEventListener('click', function() {
            this.parentNode.style.display = "none";
        }, true);
        close.appendChild(window.document.createTextNode("x"));
        recommendersquat.appendChild(close);
    }
}

function embedFunction(s) {
    document.body.appendChild(document.createElement('script')).innerHTML = s.toString().replace(/([\s\S]*?return;){2}([\s\S]*)}/, '$2');
}

function showRecs() {
    window.location = window.location + (new String(window.location).indexOf('?') == -1 ? "?" : "&") + "rtr=true";
}

function displaySquatter(sContent, bDraggable) {
    var sRecHeader = '<div id="recommendertop" style="margin: 2px 3px 2px 3px; padding: 0px;"><img src="' + sBaseUrl + '/images/folksemantic/logo-folksemantic-gm.gif" style="vertical-align:middle;"/><span style="padding-left:5px;font-size:14px;color: #777; font-weight: bold;">';
    var recommendersquat = document.createElement('div');
    recommendersquat.innerHTML = sRecHeader + sContent;
    squatParent.insertBefore(recommendersquat, squatSibling);
    positionSquatter(recommendersquat, bDraggable);
}

function displayGetRecsButton() {
    displaySquatter('<input type="button" onclick="showRecs();" value="Get Recommendations"/></span></div>', false);
}

function getRecs(sUrl) {
    GM_xmlhttpRequest(
    {
        method: 'GET',
        url: sUrl,
        headers: {'User-agent': 'Mozilla/4.0 (compatible) Greasemonkey/0.3'},

        onload: function(responseDetails)
        {
            var dom = new DOMParser().parseFromString(responseDetails.responseText, "application/xml");
            var root = dom.getElementsByTagName('recommendations')[0];
            var recommendations = dom.getElementsByTagName('recommendation');
            if (recommendations.length > 0) {
                displaySquatter(root.getAttribute("title") + '</span></div>' + recList(recommendations, root.getAttribute("direct_link_text")) + morePrompt(root), true);
            } else {
                if (bUserRequest)
                    displaySquatter('Nothing found</span></div>', false);
                else
                    displayGetRecsButton();
            }
        }
    });
}

var sBaseUrl = 'http://www.folksemantic.com/';
//var sBaseUrl = 'http://localhost:3000/';
var sServiceUrl = sBaseUrl + 'recommendations.xml?';
var sShowDocUrl = sBaseUrl + 'resources/';
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
var body = null;
var bUserRequest = userRequest(sUrlToGetRecsFor);
var bodyTags = document.getElementsByTagName('body');
var demoDomains = ['http://ocw.mit.edu','http://www.engineeringpathway.com'];
var blacklistedDomains = ['http://www.folksemantic.com','http://www.ocwfinder.org','http://www.oerrecommender.org'];
if (bodyTags && bodyTags.length > 0)
{
    sUrlToGetRecsFor = special_website_url(sUrlToGetRecsFor);
    body = bodyTags[0];
    if ((bNeeds == true && bNeedsRecord == true) || bNeeds == false) {
        identifySquatParent();
    }
    if (squatParent != null) {
        embedFunction(showRecs);
        if (demoDomain(sUrlToGetRecsFor) || bUserRequest) {
            getRecs(sServiceUrl + (bUserRequest ? "rtr=true&" : "") + "u=" + sUrlToGetRecsFor);
        } else if (!blacklistedDomain(sUrlToGetRecsFor)) {
            displayGetRecsButton();
        }
    }
}
