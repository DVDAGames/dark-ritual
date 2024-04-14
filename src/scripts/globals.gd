class_name Globals
extends Node

enum LayerTypes {
  WALLS = 1,
  PLATFORMS = 2,
  VOID = 3,
  TRIGGERS = 4
}

static var tileSize := 64

static var Levels := [
  "res://scenes/demo.tscn",
  "res://scenes/level-one.tscn",
  "res://scenes/level-two.tscn"
]

static var Items := {
  fire_amulet = "Fire Amulet"
}

static var ItemDescriptions := {
  fire_amulet = "Press SPACEBAR to case Firebolt."
}

static var LevelPositions:Array[Vector2] = [
  Vector2(0,0),
  Vector2(0,0),
  Vector2(0,0)
]

static var currentLevel := 0
static var currentHealth := 3
static var levelStartingHealth := currentHealth
static var keys := 0
static var levelStartingKeys := keys
static var currentItems: PackedStringArray = []
static var levelStartingItems := currentItems

static var Layers := LayerTypes
