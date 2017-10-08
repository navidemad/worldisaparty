;'use strict';

(function AppJs(globals) {

  var initPage = function(event) {
    if (typeof ga === 'function') {
      ga('set', 'location', location.pathname);
      ga('send', 'pageview');
    }
  };

  $(document).on('turbolinks:load', function (e) {
    initPage(e);
  });

})(window);
