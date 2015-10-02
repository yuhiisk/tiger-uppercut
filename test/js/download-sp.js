(function(win, doc) {
  'use strict';
  var Util, query;
  Util = Staircase.Util;
  query = Util.getQueryString();
  if (query.image_uuid == null) {
    return;
  }
  return $('.btn__item--back').attr('href', "/recognition/result/" + query.image_uuid);
})(window, window.document);
