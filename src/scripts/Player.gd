extends Area2D

var tileSize := 64

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


@onready var currentForm := forms.CLERIC
@onready var ray := $RayCast2D
@onready var tileMapNode := get_node("../Map")
@onready var hudHp := get_node("../HUD/HP")


# Called when the node enters the scene tree for the first time.
func _ready():
  ray.set_collision_mask_value(Globals.Layers.WALLS, false)
  ray.set_collision_mask_value(Globals.Layers.VOID, true)
  ray.set_collision_mask_value(Globals.Layers.PLATFORMS, true)

  position = position.snapped(Vector2.ONE * tileSize)
  position += Vector2.ONE * tileSize / 2

  # HACK: for some reason the intial player state can clip through the walls and into the void
  # swapping the model to the Cleric model fixes the collision detection
  swap(forms.GHOST, true)

  updateHp()

func updateHp():
  if hudHp != null:
    hudHp.set_text(str("Rituals Left: ", Globals.currentHealth))

func startPosition():
  # try to put player back at last position in scene
  if not Globals.LevelPositions.is_empty() and Globals.LevelPositions[Globals.currentLevel] != Vector2(0,0):
    position = Globals.LevelPositions[Globals.currentLevel]
  else:
    Globals.LevelPositions[Globals.currentLevel] = position

func _unhandled_input(event):
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
  if canMove(direction):
    position += direction * tileSize


func canMove(direction):
  ray.target_position = direction * tileSize
  ray.force_raycast_update()

  return ray.is_colliding()


func useAction():
    if action == "swap":
      swap(currentForm)
    elif action == "next":
      Globals.LevelPositions[Globals.currentLevel] = position
      get_tree().change_scene_to_file(Globals.Levels[Globals.currentLevel + 1])
    elif action == "back":
      get_tree().change_scene_to_file(Globals.Levels[Globals.currentLevel - 1])

    if actionMovement != null:
      position += actionMovement * tileSize


    action = ""
    actionMovement = Vector2(0,0)


func _on_ritual_circle_area_entered(area, direction):
  if currentForm == forms.CLERIC and Globals.currentHealth > 0:
    action = "swap"
    actionMovement = direction


func _on_flame_area_entered(area, direction):
  if currentForm == forms.GHOST:
    action = "swap"
    actionMovement = direction


func _on_goal_area_entered(area):
  action = "next"
  actionMovement = Vector2(0,0)


func _on_back_area_entered(area):
  action = "back"
  actionMovement = Vector2(0,0)
