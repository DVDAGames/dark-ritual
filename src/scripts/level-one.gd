extends Node2D


# handle escape input to quit the game
func _input(event):
  if event.is_action_pressed("ui_quit"):
    get_tree().quit()


func _ready():
  Globals.currentLevel = 1
  Globals.levelStartingHealth = Globals.currentHealth
  Globals.levelStartingKeys = Globals.keys
  Globals.levelStartingItems = Globals.currentItems
  $Player.startPosition()
