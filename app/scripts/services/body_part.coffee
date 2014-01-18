'use strict';

BodyPart = (data, scope, webStorage) ->
  self = this
  @scope = scope
  @webStorage = webStorage

  @boost = []

  for setting of data
    self[setting] = data[setting]

  @bought = @webStorage.get('body_part[' + @id + ']') || false

  @character = =>
    @scope.character

  @buy = =>
    @bought = true
    scope.character.bodyPartBought(self)
    @save()

  @unbuy = =>
    @bought = false
    @save()

  @save = =>
    @webStorage.add 'body_part[' + @id + ']', @bought

  @buyable = =>
    res = @cost <= @character().stamina && !@bought
    for needed in @needs || []
      res &&= @character().bodyPart(needed).bought
    res

  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'BodyPart', ['$rootScope', ($rootScope, webStorage) ->
  BodyPart
]
