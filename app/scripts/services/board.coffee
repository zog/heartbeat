'use strict';

Board = (scope, webStorage) ->
  self = this
  @area = $(".board")
  @window = $(".window")
  @area.css 'background-color', 'black'
  @scope = scope
  @tiles = []
  @width = @area.width()
  @maxDepth = 0
  @webStorage = webStorage

  @resizeWindow = (tile) =>
    w = tile.left + tile.width
    return unless w > @window.width()
    @area.width(w) if @area.width() < w
    @window.scrollLeft(w)

  @addTile = (resource) =>
    t = new BoardTile(self, resource)
    @tiles.push t
    @resizeWindow t
    @save()

  @save = =>
    @webStorage.add 'board', {tiles: @tiles.map (tile)-> {x: tile.x, y: tile.y, resource: tile.resource_id, level: tile.level}}

  stored = @webStorage.get('board') || {}
  for data in stored.tiles
    t = new BoardTile(self, null, data)
    @tiles.push t
    @maxDepth += 1
    @resizeWindow t
    @save()

  self

BoardTile = (board, resource, data={}) ->
  self = this
  @height = 100
  @width = 80
  @yOffest = 150

  @resource_id = resource and resource.id || data.resource
  @level = resource and resource.level || data.level

  @board = board
  @x = data.x
  unless @x
    @x = board.maxDepth
    @board.maxDepth += 1

  @y = data.y
  unless @y
    @y = parseInt Math.random()*3

  @left = Math.max(0, (@x + Math.random()) * @width)
  @top = parseInt(@yOffest + Math.min(3, @y + Math.random()) * @height)

  @remove = =>
    @board.tiles = @board.tiles.filter (tile) => tile.resource.id isnt self.resource.id
  self

heartbeatServices = angular.module 'heartbeatServices'

heartbeatServices.factory 'Board', ['$rootScope', ($rootScope, webStorage) ->
  Board
]
