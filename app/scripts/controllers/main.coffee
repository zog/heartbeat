'use strict'

angular.module('heartbeatApp')
  .controller('MainCtrl', ['$scope', 'Character', 'webStorage', '$http', 'Bonus', ($scope, Character, webStorage, $http, Bonus) =>
    $http.get('data/bonuses.json').success (data) =>
      bonuses = []
      for bonus in data
        bonuses.push new Bonus bonus, $scope, webStorage
      $scope.bonuses = bonuses
      $scope.character = new Character $scope, webStorage, bonuses
      $scope.showResetPopup = (options=true) =>
        if options
            $scope.displayLocationDeletePopup = true
        else
            $scope.displayLocationDeletePopup = false
  ])

