'use strict';

angular.module('heartbeatApp')
  .controller('MainCtrl', ['$scope', 'Character', function ($scope, Character) {
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS',
      'Karma'
    ];
    $scope.character = new Character($scope);
  }]);
