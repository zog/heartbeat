'use strict';

Character = (scope, webStorage, bonuses) ->
  self = this
  @scope = scope
  @webStorage = webStorage
  @bonuses = bonuses

  @stamina =      @webStorage.get('stamina') || 0
  @baseBrain =    @webStorage.get('brain') || 0
  @brainBonusFactor = 1
  @staminaBonusFactor = 1

  @incrementStamina = (val=null) =>
    val = @defaultIncrement() unless val?
    @stamina += val
    @save()

  @decrementStamina = (val) =>
    @stamina -= val
    @save()

  @bonusBought = (bonus) =>
    @decrementStamina bonus.cost
    @computeBonusFactors()

  @period = ->
    100.0

  @longPeriod = ->
    10000.0

  @computeBonusFactors = =>
    @brainBonusFactor = 1
    @staminaBonusFactor = 1
    for bonus in @bonuses
      if bonus.bought
        @brainBonusFactor += (bonus.boost.brain_percent / 100 || 0)
        @staminaBonusFactor += (bonus.boost.stamina_percent / 100 || 0)

  @brain = =>
    @baseBrain * @brainBonusFactor

  @brainFactor = ->
    Math.sqrt(@brain() * 10)

  @defaultIncrement = ->
    @brainFactor() * @period() / 1000 * @staminaBonusFactor

  @defaultIncrementPerS = ->
    @defaultIncrement() * 1000 / @period()

  @conversionRate = ->
    0.1 / Math.max(@brainFactor(), 1)

  @convert = =>
    @baseBrain += @stamina * @conversionRate()
    @stamina = 0
    @computeBonusFactors()
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
    @webStorage.add 'brain', @baseBrain

  @reset = =>
    @stamina = @baseBrain = 0
    @brainBonusFactor = @staminaBonusFactor = 1
    for bonus in @bonuses
      bonus.unbuy()
    @save()

  # We cannot call `tick` because of the $apply
  setTimeout =>
      @tick()
    , @period()

  @computeBonusFactors()
  @tack()

  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'Character', ['$rootScope', ($rootScope, webStorage) ->
  Character
]
