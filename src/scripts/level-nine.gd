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
  Globals.currentStep = 0

  $Player.startPosition()
  $Player.swap(2, true)


func _on_boom_sound_timer_timeout():
  $BoomSoundTimer.wait_time = 0.1
  $BoomSoundTimer.start()
  $BoomEffect.play()
  $CollapsePlatformTimer.start()
  $HUD/Tooltip.visible = false
  $HUD/Tooltip.set_text("")


func _on_collapse_platform_timer_timeout():
  $BoomSoundTimer.stop()
  Globals.LevelPositions[Globals.currentLevel] = $Player.position
  get_tree().change_scene_to_file("res://scenes/level-nine-pt2.tscn")
