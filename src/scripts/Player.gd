extends Area2D

var inputs := {
  "ui_right": Vector2.RIGHT,
  "ui_left": Vector2.LEFT,
  "ui_up": Vector2.UP,
  "ui_down": Vector2.DOWN
}

var clericTexture := load("res://sprites/cleric.png")
var ghostTexture := load("res://sprites/ghost.png")

enum forms {
  CLERIC = 1,
  GHOST = 2
}

var action := ""
var actionMovement := Vector2(0,0)
var actionItem := ""
# TODO: REVERT AFTER TESTING
var canCastFirebolt:= true

@export var Firebolt: PackedScene = preload("res://scenes/fire_bolt.tscn")

@onready var currentForm := forms.CLERIC
@onready var ray := $RayCast2D
@onready var tileMapNode := get_node("../Map")
@onready var hudHp := get_node("../HUD/HP")
@onready var hudKeys := get_node("../HUD/Keys")
@onready var tooltip := get_node("../HUD/Tooltip")

# Called when the node enters the scene tree for the first time.
func _ready():
  ray.set_collision_mask_value(Globals.Layers.WALLS, false)
  ray.set_collision_mask_value(Globals.Layers.VOID, true)
  ray.set_collision_mask_value(Globals.Layers.PLATFORMS, true)

  position = position.snapped(Vector2.ONE * Globals.tileSize)
  position += Vector2.ONE * Globals.tileSize / 2

  # HACK: for some reason the intial player state can clip through the walls and into the void
  # swapping the model to the Cleric model fixes the collision detection
  if Globals.currentLevel == 5:
    print('GHOST')
    currentForm = forms.GHOST
    swap(forms.CLERIC, true)
  else:
    swap(forms.GHOST, true)

  $Caster.transform = Transform2D(0.0, position)

  if Globals.currentItems.has("fire_amulet"):
    canCastFirebolt = true

  updateHp()
  updateKeys()

func updateHp():
  if hudHp != null:
    hudHp.set_text(str("Rituals Left: ", Globals.currentHealth))

  if Globals.currentHealth == 0:
    get_tree().call_group("rituals", "enter_disabled_mode")
  else:
    get_tree().call_group("rituals", "exit_disabled_mode")

func updateKeys():
  if hudKeys != null:
    hudKeys.set_text(str("Keys: ", Globals.keys))

func startPosition():
  # try to put player back at last position in scene
  if not Globals.LevelPositions.is_empty() and Globals.LevelPositions[Globals.currentLevel] != Vector2(0,0):
    position = Globals.LevelPositions[Globals.currentLevel]
  else:
    Globals.LevelPositions[Globals.currentLevel] = position

func _unhandled_input(event):
  if event.is_action_pressed("ui_reset"):
    Globals.LevelPositions[Globals.currentLevel] = Vector2(0,0)
    Globals.currentHealth = Globals.levelStartingHealth
    Globals.keys = Globals.levelStartingKeys
    get_tree().change_scene_to_file(Globals.Levels[Globals.currentLevel])


  if event.is_action_pressed("ui_swap"):
    # swap sprite
    swap(currentForm)

  if event.is_action_pressed("ui_action"):
    useAction()

  for direction in inputs.keys():
    if event.is_action_pressed(direction):
      move(inputs[direction])


func swap(form, special = false):
  if form == forms.CLERIC:
    $PlayerSprite.set_texture(ghostTexture)

    ray.set_collision_mask_value(Globals.Layers.WALLS, false)
    ray.set_collision_mask_value(Globals.Layers.VOID, true)
    ray.set_collision_mask_value(Globals.Layers.PLATFORMS, false)

    currentForm = forms.GHOST

    get_tree().call_group("flames", "enter_interactive_mode")
    get_tree().call_group("rituals", "exit_interactive_mode")

    if not special:
      Globals.currentHealth -= 1
      updateHp()
  else:
    $PlayerSprite.set_texture(clericTexture)

    ray.set_collision_mask_value(Globals.Layers.WALLS, false)
    ray.set_collision_mask_value(Globals.Layers.VOID, false)
    ray.set_collision_mask_value(Globals.Layers.PLATFORMS, true)

    currentForm = forms.CLERIC

    get_tree().call_group("flames", "exit_interactive_mode")
    get_tree().call_group("rituals", "enter_interactive_mode")


func move(direction):
  #which direction are we facing for firebolt casts?
  if direction == Vector2(0, -1): #up
    $Caster.transform = Transform2D(deg_to_rad(-90), position)
  elif direction == Vector2(1, 0): #right
    $Caster.transform = Transform2D(0.0, position)
  elif direction == Vector2(0, 1): #down
    $Caster.transform = Transform2D(deg_to_rad(90), position)
  elif direction == Vector2(-1, 0): #left
    $Caster.transform = Transform2D(deg_to_rad(180), position)

  if canMove(direction):
    position += direction * Globals.tileSize

    $Caster.position = position


func canMove(direction):
  ray.target_position = direction * Globals.tileSize
  ray.force_raycast_update()

  return ray.is_colliding()


func useAction():
    # PERFORM ACTION
    if action == "swap":
      swap(currentForm)
    elif action == "next":
      Globals.LevelPositions[Globals.currentLevel] = position
      get_tree().change_scene_to_file(Globals.Levels[Globals.currentLevel + 1])
    elif action == "back":
      get_tree().change_scene_to_file(Globals.Levels[Globals.currentLevel - 1])
    elif action == "key":
      Globals.keys += 1

      updateKeys()

      get_tree().call_group("keys", "exit_interactive_mode")
    elif action == "potion":
      Globals.currentHealth = 3

      updateHp()

      get_tree().call_group("potions", "exit_interactive_mode")
    elif action == "unlock":
      Globals.keys -= 1
      Globals.currentItems.append(actionItem)

      var itemName = Globals.Items[actionItem]

      if actionItem == "fire_amulet":
        canCastFirebolt = true

      if tooltip != null:
        tooltip.set_text(str("You picked up the ", itemName, ". ", Globals.ItemDescriptions[actionItem]))

      updateKeys()

      get_tree().call_group("chests", "exit_interactive_mode")
    elif action == "void":
      if Globals.currentLevel == 4:
        Globals.LevelPositions[Globals.currentLevel] = position
        get_tree().change_scene_to_file("res://scenes/level-five.tscn")
      elif Globals.currentLevel == 5:
        Globals.LevelPositions[Globals.currentLevel] = position
        get_tree().change_scene_to_file("res://scenes/level-six.tscn")
    elif action == "ritual":
      get_tree().call_group("braziers", "ignite")

      get_tree().call_group("voids", "appear")
    elif currentForm == forms.CLERIC and Globals.currentItems.has("fire_amulet") and canCastFirebolt:
      castFirebolt()

    # MOVE IF NECESSARY
    if actionMovement != Vector2(0,0):
      position += actionMovement * Globals.tileSize

    # RESET ACTION
    action = ""
    actionMovement = Vector2(0,0)
    actionItem = ""


func castFirebolt():
  canCastFirebolt = false

  var firebolt = Firebolt.instantiate()

  firebolt.add_to_group("firebolts")

  owner.add_child(firebolt)

  firebolt.position = $Caster.position
  firebolt.transform = $Caster.transform
  $FireboltCooldown.start()


func _on_ritual_circle_area_entered(_area, direction):
  if currentForm == forms.CLERIC and Globals.currentHealth > 0:
    tooltip.set_text("Press SPACEBAR to perform the blood ritual and become ethereal.")
    tooltip.visible = true

    action = "swap"
    actionMovement = direction


func _on_flame_area_entered(_area, direction):
  if currentForm == forms.GHOST:
    tooltip.set_text("Press SPACEBAR to consume the unholy flame and become corporeal.")
    tooltip.visible = true

    action = "swap"
    actionMovement = direction


func _on_goal_area_entered(_area):
  tooltip.set_text("Press SPACEBAR to venture on.")
  tooltip.visible = true

  action = "next"
  actionMovement = Vector2(0,0)


func _on_back_area_entered(_area):
  tooltip.set_text("Press SPACEBAR to turn back.")
  tooltip.visible = true

  action = "back"
  actionMovement = Vector2(0,0)


func _on_ritual_circle_area_exited(_area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)


func _on_flame_area_exited(_area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)


func _on_goal_area_exited(_area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)


func _on_back_area_exited(_area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)


func _on_key_area_entered(_area):
  tooltip.set_text("Press SPACEBAR to pick up the key.")
  tooltip.visible = true

  action = "key"
  actionMovement = Vector2(0,0)


func _on_key_area_exited(_area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)


func _on_potion_area_entered(_area):
  if Globals.currentHealth < 3:
    tooltip.set_text("Press SPACEBAR to drink the blood potion.")
    tooltip.visible = true

    action = "potion"
    actionMovement = Vector2(0,0)
  else:
    tooltip.set_text("A blood potion, but I'm feeling fine.")
    tooltip.visible = true


func _on_potion_area_exited(_area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)


func _on_chest_area_entered(_area, item):
  if Globals.keys > 0:
    tooltip.set_text("Press SPACEBAR to unlock the chest.")
    tooltip.visible = true

    action = "unlock"
    actionMovement = Vector2(0,0)
    actionItem = item
  else:
    tooltip.set_text("This chest is locked.")
    tooltip.visible = true


func _on_chest_area_exited(_area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)


func _on_firebolt_cooldown_timeout():
  canCastFirebolt = true


func _on_ethereal_door_area_entered(_area):
  tooltip.set_text("Press SPACEBAR to enter the ethereal void.")
  tooltip.visible = true

  action = "void"
  actionMovement = Vector2(0,0)


func _on_ethereal_door_area_exited(_area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)


func _on_brazier_area_entered(_area):
  if Globals.currentLevel == 6:
    if currentForm == 2:
      if Globals.currentItems.has("unholy_flame"):
        tooltip.set_text("Press SPACEBAR to channel the unholy flame and light the brazier.")
        tooltip.visible = true

        action = "ritual"
        actionMovement = Vector2(0,0)
      else:
        tooltip.set_text("An unlit brazier filled with incense and some kind of oil.")
        tooltip.visible = true


func _on_brazier_area_exited(area):
  tooltip.visible = false
  tooltip.set_text("")

  action = ""
  actionMovement = Vector2(0,0)
