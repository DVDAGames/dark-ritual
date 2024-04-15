extends Node2D

# handle escape input to quit the game
func _input(event):
  if event.is_action_pressed("ui_quit"):
    get_tree().quit()


func _ready():
  Globals.currentLevel = 9
  Globals.levelStartingHealth = Globals.currentHealth
  Globals.levelStartingKeys = Globals.keys
  Globals.levelStartingItems = Globals.currentItems
  Globals.currentStep = 1

  $Player.startPosition()
  $Player.swap(2, true)

  $HUD/Tooltip.set_text("The dark wizard has been defeated. But there's haunting chant coming from the abyss below.")
  $HUD/Tooltip.visible = true


func _on_timer_timeout():
  get_tree().change_scene_to_file("res://scenes/outro.tscn")
