'use strict';

Bonus = (data, scope, webStorage) ->
  self = this
  @scope = scope
  @webStorage = webStorage

  for setting of data
    self[setting] = data[setting]

  @bought = @webStorage.get('bonus[' + @id + ']') || false

  @buy = =>
    console.log "bought " + @name
    @bought = true
    @save()

  @save = =>
    @webStorage.add 'bonus[' + @id + ']', @bought

  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'Bonus', ['$rootScope', ($rootScope, webStorage) ->
  Bonus
]
