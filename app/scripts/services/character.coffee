'use strict';

Character = (scope) ->
  self = this
  @stamina = 0
  @brain = 0
  @scope = scope

  @incrementStamina = (val=null) =>
    val = @defaultIncrement() unless val?
    @stamina += val

  @period = ->
    100.0

  @brainLog = ->
    Math.log(@brain || 1) / Math.log(1.2) || 1

  @defaultIncrement = ->
    @brainLog() * @period() / 1000

  @defaultIncrementPerS = ->
    @defaultIncrement() * 1000 / @period()

  @conversionRate = ->
    1 / @defaultIncrement()

  @convert = =>
    @brain += Math.ceil(@stamina * @conversionRate())
    @stamina = 0

  @tick = =>
    @incrementStamina()
    @scope.$apply()
    setTimeout =>
      @tick()
    , @period()

  # We cannot call `tick` because of the $apply
  setTimeout =>
      @tick()
    , @period()

  self

heartbeatServices = angular.module 'heartbeatServices', []

heartbeatServices.factory 'Character', ['$rootScope', ($rootScope) ->
  Character
]
