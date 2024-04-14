class_name Globals
extends Node

enum LayerTypes {
  WALLS = 1,
  PLATFORMS = 2,
  VOID = 3,
  TRIGGERS = 4
}

static var Levels := [
  "res://scenes/demo.tscn",
  "res://scenes/level-one.tscn",
  "res://scenes/level-two.tscn"
]

static var LevelPositions:Array[Vector2] = [
  Vector2(0,0),
  Vector2(0,0),
  Vector2(0,0),
]

static var currentLevel := 0

static var Layers := LayerTypes
