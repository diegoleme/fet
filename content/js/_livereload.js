(function ($) {
  'use strict';

  if (location.host.split(':')[0] === 'localhost') {
    $.ajax({
      url: '//localhost:35729/livereload.js',
      dataType: 'script'
    })
  }
})(jQuery)
