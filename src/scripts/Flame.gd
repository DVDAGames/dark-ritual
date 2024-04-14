extends Area2D

@export var wasConsumed := false


func enter_interactive_mode():
  visible = true


func exit_interactive_mode():
  visible = false


func consume_flame():
  modulate.a = 127
  wasConsumed = true


func light_flame():
  modulate.a = 255
  wasConsumed = false
