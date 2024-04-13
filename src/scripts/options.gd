extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
  $MarginContainer/VBoxContainer/BackButton.grab_focus()

# handle escape input to quit the game
func _input(event):
  if event.is_action_pressed("ui_quit"):
    get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func _on_back_button_pressed():
  get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
