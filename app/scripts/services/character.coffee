'use strict';

Character = (scope, webStorage) ->
  self = this
  @scope = scope
  @webStorage = webStorage

  @stamina =  @webStorage.get('stamina') || 0
  @brain =    @webStorage.get('brain') || 0

  @incrementStamina = (val=null) =>
    val = @defaultIncrement() unless val?
    @stamina += val
    @save()

  @period = ->
    100.0

  @longPeriod = ->
    10000.0

  @brainLog = ->
    Math.log(@brain || 1) / Math.log(1.2) || 1

  @defaultIncrement = ->
    @brainLog() * @period() / 1000

  @defaultIncrementPerS = ->
    @defaultIncrement() * 1000 / @period()

  @conversionRate = ->
    1 / @defaultIncrement()

  @convert = =>
    @brain += @stamina * @conversionRate()
    @stamina = 0
    @save()

  @tick = =>
    @incrementStamina()
    @scope.$apply()
    setTimeout =>
      @tick()
    , @period()

  @tack = =>
    @save()
    setTimeout =>
      @tack()
    , @longPeriod()

  @save = =>
    @webStorage.add 'stamina', @stamina
    @webStorage.add 'brain', @brain

  # We cannot call `tick` because of the $apply
  setTimeout =>
      @tick()
    , @period()

  @tack()

  self

heartbeatServices = angular.module 'heartbeatServices', ['webStorageModule']

heartbeatServices.factory 'Character', ['$rootScope', ($rootScope, webStorage) ->
  Character
]
