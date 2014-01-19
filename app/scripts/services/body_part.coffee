'use strict';

BodyPart = (data, scope, webStorage) ->
  self = this
  @scope = scope
  @webStorage = webStorage

  @boost = []
  @maxLevel = 99

  for setting of data
    self[setting] = data[setting]

  @level = @webStorage.get('body_part[' + @id + ']') || 0
  @bought = !!@level

  @character = =>
    @scope.character

  @upgradeCost = =>
    (@level + 1) * (@level + 1) * @cost

  @upgrade = =>
    cost = @upgradeCost()
    @bought = true
    @level += 1
    scope.character.bodyPartBought(self, cost)
    @save()

  @unbuy = =>
    @bought = false
    @level = 0
    @save()

  @boostBrainPercent = =>
    @boost.brainPercent * @level

  @boostStaminaPercent = =>
    @boost.staminaPercent * @level

  @save = =>
    @webStorage.add 'body_part[' + @id + ']', @level

  @seeable = =>
    res = true
    for needed in @needs || []
      res &&= @character().bodyPart(needed).bought
    res

  @buyable = =>
    @seeable() && @upgradeCost() <= @character().stamina && @level < @maxLevel

  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'BodyPart', ['$rootScope', ($rootScope, webStorage) ->
  BodyPart
]
