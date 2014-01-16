'use strict';

Bonus = (data, scope, webStorage) ->
  self = this
  @scope = scope
  @webStorage = webStorage

  for setting of data
    self[setting] = data[setting]

  @bought = @webStorage.get('bonus[' + @id + ']') || false

  @buy = =>
    @bought = true
    scope.character.decrementStamina(@cost)
    @save()

  @unbuy = =>
    @bought = false
    @save()

  @save = =>
    @webStorage.add 'bonus[' + @id + ']', @bought

  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'Bonus', ['$rootScope', ($rootScope, webStorage) ->
  Bonus
]
