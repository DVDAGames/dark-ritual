extends Node2D

static var intro_done = false

# handle escape input to quit the game
func _input(event):
  if event.is_action_pressed("ui_quit"):
    get_tree().quit()

func _ready():
  Globals.currentLevel = 1
  $Player.startPosition()


func _on_audio_stream_player_finished():
  $BGMusic.play()


func _on_bg_music_timer_timeout():
  $BGMusic.play()
