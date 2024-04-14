extends Node2D

var tileSize = 64


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  $Wizard.position += Vector2(1, 0) * tileSize * delta


func _on_laugh_sound_timer_timeout():
  $Wizard/WizardLaugh.play()


func _on_boom_sound_timer_timeout():
  $BoomSoundTimer.wait_time = 0.1
  $BoomSoundTimer.start()
  $BoomEffect.play()
  $Camera2D.applyShake()


func _on_collapse_bridge_timer_timeout():
  $BoomSoundTimer.stop()
  get_tree().change_scene_to_file("res://scenes/demo.tscn")
