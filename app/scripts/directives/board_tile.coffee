angular.module('heartbeatApp').directive 'boardTile', =>
  {
    restrict: 'A',
    template: '<div class="inner {{tile.resource_id}}"></div>'
  }
