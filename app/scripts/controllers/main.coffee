'use strict'

angular.module('heartbeatApp')
  .controller('MainCtrl', ['$scope', 'Character', 'webStorage', '$http', 'Bonus', 'Resource', 'Board', ($scope, Character, webStorage, $http, Bonus, Resource, Board) =>
    $http.get('data/resources.json').success (data) =>
      resources = []
      for resource in data
        resources.push new Resource resource, $scope, webStorage
      $scope.resources = resources
      $scope.character.resources = resources
      $scope.character.computeBonusFactors()

    $http.get('data/bonuses.json').success (data) =>
      bonuses = []
      for bonus in data
        bonuses.push new Bonus bonus, $scope, webStorage
      $scope.bonuses = bonuses
      $scope.character.bonuses = bonuses
      $scope.character.computeBonusFactors()

    $scope.character = new Character $scope, webStorage
    $scope.board = new Board $scope, webStorage
    $scope.showResetPopup = (options=true) =>
      if options
          $scope.displayLocationDeletePopup = true
      else
          $scope.displayLocationDeletePopup = false
  ])

