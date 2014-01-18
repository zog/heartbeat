'use strict'

angular.module('heartbeatApp')
  .controller('MainCtrl', ['$scope', 'Character', 'webStorage', '$http', 'Bonus', 'BodyPart', ($scope, Character, webStorage, $http, Bonus, BodyPart) =>
    $http.get('data/body_parts.json').success (data) =>
      bodyParts = []
      for part in data
        bodyParts.push new BodyPart part, $scope, webStorage
      $scope.bodyParts = bodyParts
      $scope.character.bodyParts = bodyParts
      $scope.character.computeBonusFactors()

    $http.get('data/bonuses.json').success (data) =>
      bonuses = []
      for bonus in data
        bonuses.push new Bonus bonus, $scope, webStorage
      $scope.bonuses = bonuses
      $scope.character.bonuses = bonuses
      $scope.character.computeBonusFactors()

    $scope.character = new Character $scope, webStorage
    $scope.showResetPopup = (options=true) =>
      if options
          $scope.displayLocationDeletePopup = true
      else
          $scope.displayLocationDeletePopup = false
  ])

