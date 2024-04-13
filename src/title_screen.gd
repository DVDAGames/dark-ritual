extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
  $MarginContainer/VBoxContainer/StartButton.grab_focus()

# handle escape input to quit the game
func _input(event):
  if event.is_action_pressed("ui_quit"):
    get_tree().quit()


func _on_start_button_pressed():
  get_tree().change_scene_to_file("res://demo.tscn")


func _on_quit_button_pressed():
  get_tree().quit()


func _on_options_button_pressed():
  get_tree().change_scene_to_file("res://options.tscn")
