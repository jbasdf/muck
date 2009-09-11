// from http://blog.peelmeagrape.net/2008/7/26/time-ago-in-words-javascript-part-1
function distanceOfTimeInWords(fromTime, toTime, includeSeconds) {
  var fromSeconds = fromTime.getTime();
  var toSeconds = toTime.getTime();
  var distanceInSeconds = Math.round(Math.abs(fromSeconds - toSeconds) / 1000)
  var distanceInMinutes = Math.round(distanceInSeconds / 60)
  if (distanceInMinutes <= 1) {
    if (!includeSeconds)
      return (distanceInMinutes == 0) ? 'less than a minute' : '1 minute'
    if (distanceInSeconds < 5)
      return 'less than 5 seconds'
    if (distanceInSeconds < 10)
      return 'less than 10 seconds'
    if (distanceInSeconds < 20)
      return 'less than 20 seconds'
    if (distanceInSeconds < 40)
      return 'half a minute'
    if (distanceInSeconds < 60)
      return 'less than a minute'
    return '1 minute'
  }
  if (distanceInMinutes < 45)
    return distanceInMinutes + ' minutes'
  if (distanceInMinutes < 90)
    return "about 1 hour" 
  if (distanceInMinutes < 1440)
    return "about " + (Math.round(distanceInMinutes / 60)) + ' hours'
  if (distanceInMinutes < 2880)
    return "1 day" 
  if (distanceInMinutes < 43200)
    return (Math.round(distanceInMinutes / 1440)) + ' days'
  if (distanceInMinutes < 86400)
    return "about 1 month" 
  if (distanceInMinutes < 525600)
    return (Math.round(distanceInMinutes / 43200)) + ' months'
  if (distanceInMinutes < 1051200)
    return "about 1 year" 
  return "over " + (Math.round(distanceInMinutes / 525600)) + ' years'
}

if ( typeof jQuery != "undefined" )
	jQuery.fn.readableDate = function(){
		return this.each(function(){
			var span = jQuery(this);
			var date = distanceOfTimeInWords(new Date(span.text()), new Date(), true);
			if (date)
				jQuery(this).text(date + ' ago');
		});
	};

jQuery(document).ready(function() {
	jQuery(".readable-time").readableDate();
});