extends Area2D

@export var wasPerformed = false

func perform_ritual():
  modulate.a = 127
  wasPerformed = true


func restore_ritual():
  modulate.a = 255
  wasPerformed = false


func enter_interactive_mode():
  visible = true


func exit_interactive_mode():
  visible = false


func enter_disabled_mode():
  modulate.a = 127


func exit_disabled_mode():
  modulate.a = 255
