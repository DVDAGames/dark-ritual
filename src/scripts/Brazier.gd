extends Area2D


@export var isLit = false

@onready var tooltip := get_node("../HUD/Tooltip")
@onready var Player := get_node("../Player")
@onready var BoomSoundTimer := get_node("../BoomSoundTimer")
@onready var BoomEffect := get_node("../BoomEffect")
@onready var CollapsePlatformTimer := get_node("../CollapsePlatformTimer")
@onready var camera := get_node("../Camera2D")

func ignite():
  if not isLit:
    $LitBrazier.visible = true
    $UnlitBrazier.visible = false

    isLit = true


func hit_by_firebolt():
  if not isLit:
    $LitBrazier.visible = true
    $UnlitBrazier.visible = false

    isLit = true

    add_to_group("lit_braziers")

    if Globals.currentLevel == 3:
      Globals.LevelPositions[Globals.currentLevel] = Player.position

      if Globals.currentStep == 0:
        get_tree().change_scene_to_file("res://scenes/level-three-pt2.tscn")
      elif Globals.currentStep == 1:
        get_tree().change_scene_to_file("res://scenes/level-three-pt3.tscn")
    elif Globals.currentLevel == 4:
      Globals.LevelPositions[Globals.currentLevel] = Player.position

      if Globals.currentStep == 0:
        get_tree().change_scene_to_file("res://scenes/level-four-pt2.tscn")
    elif Globals.currentLevel == 8:
      if get_tree().get_nodes_in_group("lit_braziers").size() == 8:
        get_tree().change_scene_to_file("res://scenes/level-eight-pt2.tscn")
    elif Globals.currentLevel == 9:
      if get_tree().get_nodes_in_group("lit_braziers").size() == 8:

        BoomSoundTimer.wait_time = 0.1
        BoomSoundTimer.start()
        BoomEffect.play()


func _on_area_entered(area):
  if area.is_in_group("firebolts"):
    hit_by_firebolt()
    area.queue_free()

  elif not isLit:
    if Globals.currentLevel == 3:
      if Globals.currentStep < 1:
        tooltip.set_text("An unlit brazier.")
        tooltip.visible = true
    elif Globals.currentLevel == 4:
      if Globals.currentStep < 1:
        tooltip.set_text("An unlit brazier.")
        tooltip.visible = true
    elif Globals.currentLevel != 6:
      tooltip.set_text("An unlit brazier.")
      tooltip.visible = true


func _on_area_exited(_area):
  if tooltip.visible:
    tooltip.set_text("")
    tooltip.visible = true
