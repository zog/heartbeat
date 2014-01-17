'use strict';

Bonus = (data, scope, webStorage) ->
  self = this
  @scope = scope
  @webStorage = webStorage

  for setting of data
    self[setting] = data[setting]

  @bought = @webStorage.get('bonus[' + @id + ']') || false

  @character = =>
    @scope.character

  @buy = =>
    @bought = true
    scope.character.bonusBought(self)
    @save()

  @unbuy = =>
    @bought = false
    @save()

  @save = =>
    @webStorage.add 'bonus[' + @id + ']', @bought

  @buyable = =>
    res = @cost < @character().stamina && !@bought
    for needed in @needs || []
      res &&= @character().bonus(needed).bought
    res

  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'Bonus', ['$rootScope', ($rootScope, webStorage) ->
  Bonus
]
