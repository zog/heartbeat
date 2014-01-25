'use strict';

Resource = (data, scope, webStorage) ->
  self = this
  @scope = scope
  @webStorage = webStorage

  @boost = []
  @maxLevel = 99
  @tiles = []

  for setting of data
    self[setting] = data[setting]

  @stored = @webStorage.get('resource[' + @id + ']') || {}
  @level  = @stored.level || 0
  @x  = @stored.x
  @y  = @stored.y
  @bought = !!@level

  @character = =>
    @scope.character

  @upgradeCost = =>
    (@level + 1) * (@level + 1) * @cost

  @upgrade = =>
    cost = @upgradeCost()
    @bought = true
    @level += 1
    scope.character.resourceBought(self, cost)
    @scope.board.addTile self
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
    @webStorage.add 'resource[' + @id + ']', {level: @level}

  @seeable = =>
    res = true
    for needed in @needs || []
      res &&= @character().resource(needed).bought
    res

  @buyable = =>
    @seeable() && @upgradeCost() <= @character().stamina && @level < @maxLevel

  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'Resource', ['$rootScope', ($rootScope, webStorage) ->
  Resource
]
