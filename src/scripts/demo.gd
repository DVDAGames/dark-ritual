extends Node2D

# handle escape input to quit the game
func _input(event):
  if event.is_action_pressed("ui_quit"):
    get_tree().quit()


func _on_audio_stream_player_finished():
  $AudioStreamPlayer.play()
