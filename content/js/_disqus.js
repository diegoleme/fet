/* jshint camelcase : false */
var disqus_shortname = 'frontendtalks'

;
(function ($) {
  'use strict';

  if (!!document.getElementById('disqus_thread')) {
    $.ajax({
      url: '//' + disqus_shortname + '.disqus.com/embed.js',
      dataType: 'script'
    })
  }

  $.ajax({
    url: '//' + disqus_shortname + '.disqus.com/count.js',
    dataType: 'script'
  })
})(jQuery)
