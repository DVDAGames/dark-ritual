extends Area2D


@export var isLit = false

@onready var tooltip := get_node("../HUD/Tooltip")

func hit_by_firebolt():
  if not isLit:
    $LitBrazier.visible = true
    $UnlitBrazier.visible = false

    isLit = true

    if Globals.currentLevel == 3:
      if Globals.currentStep == 0:
        get_tree().change_scene_to_file("res://scenes/level-three-pt2.tscn")
      elif Globals.currentStep == 1:
        get_tree().change_scene_to_file("res://scenes/level-three-pt3.tscn")


func _on_area_entered(area):
  if area.is_in_group("firebolts"):
    hit_by_firebolt()
    area.queue_free()

  elif not isLit:
    tooltip.set_text("An unlit brazier.")
    tooltip.visible = true

func _on_area_exited(_area):
  if tooltip.visible:
    tooltip.set_text("")
    tooltip.visible = true
