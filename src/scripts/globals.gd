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
  "res://scenes/level-two.tscn",
  "res://scenes/level-three.tscn",
  "res://scenes/level-four.tscn",
  "res://scenes/level-five.tscn",
  "res://scenes/level-six.tscn",
  "res://scenes/level-seven.tscn",
  "res://scenes/level-eight.tscn",
  "res://scenes/level-nine.tscn",
  "res://scenes/outro.tscn"
]

static var LevelSteps: Array[int] = [
  0, # demo
  0, # one
  0, # two
  2, # three
  1, # four
  0, # fixe
  0, # six
  0, #seven
  1, # eight
  1, #boss,
  0  #outro
]

static var Items := {
  fire_amulet = "Fire Amulet",
  unholy_flame = "Unholy Flame"
}

static var ItemDescriptions := {
  fire_amulet = "Press SPACEBAR to case Firebolt.",
  unholy_flame = "This unholy flame burns a dark vibrant blue."
}

static var LevelPositions:Array[Vector2] = [
  Vector2(0,0),
  Vector2(0,0),
  Vector2(0,0),
  Vector2(0,0),
  Vector2(0,0),
  Vector2(0,0),
  Vector2(0,0),
  Vector2(0,0),
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
static var currentStep := LevelSteps[currentLevel]

static var Layers := LayerTypes
