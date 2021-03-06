var applyEach, nginx, repos, series, _ref, _ref1;

_ref = require('../tasks'), nginx = _ref.nginx, repos = _ref.repos;

_ref1 = require('async'), applyEach = _ref1.applyEach, series = _ref1.series;

module.exports = function(siteName, done) {
  if (siteName != null) {
    return applyEach([repos.stopOne, nginx.stopOne], siteName, function() {
      return typeof done === "function" ? done() : void 0;
    });
  } else {
    return series([repos.stop, nginx.stop], function() {
      return typeof done === "function" ? done() : void 0;
    });
  }
};
