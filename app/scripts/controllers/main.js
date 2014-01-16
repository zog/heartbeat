'use strict';

angular.module('heartbeatApp')
  .controller('MainCtrl', ['$scope', 'Character', 'webStorage', function ($scope, Character, webStorage) {
    $scope.character = new Character($scope, webStorage);
  }]);
