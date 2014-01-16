'use strict';

Character = (scope, webStorage, bonuses) ->
  self = this
  @scope = scope
  @webStorage = webStorage
  @bonuses = bonuses

  @stamina =  @webStorage.get('stamina') || 0
  @brain =    @webStorage.get('brain') || 0

  @incrementStamina = (val=null) =>
    val = @defaultIncrement() unless val?
    @stamina += val
    @save()

  @decrementStamina = (val) =>
    @stamina -= val
    @save()

  @period = ->
    100.0

  @longPeriod = ->
    10000.0

  @brainFactor = ->
    factor = Math.log(@brain || 1) / Math.log(1.2) || 1
    for bonus in @bonuses
      if bonus.bought
        factor *= 1 + (bonus.boost.brain_percent / 100 || 0)
    factor

  @defaultIncrement = ->
    @brainFactor() * @period() / 1000

  @defaultIncrementPerS = ->
    @defaultIncrement() * 1000 / @period()

  @conversionRate = ->
    1 / @brainFactor()

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

  @reset = =>
    @stamina = @brain = 0
    for bonus in @bonuses
      bonus.unbuy()
    @save()

  # We cannot call `tick` because of the $apply
  setTimeout =>
      @tick()
    , @period()

  @tack()

  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'Character', ['$rootScope', ($rootScope, webStorage) ->
  Character
]
