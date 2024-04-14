extends Camera2D

@export var randomStrength := 30.0
@export var shakeFade := 5.0
@export var isShaking = false

var rng = RandomNumberGenerator.new()

var shakeStrength = 0.0

func applyShake():
  shakeStrength = randomStrength

func randomOffset():
  return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if shakeStrength > 0:
    shakeStrength -= lerpf(shakeStrength, 0, shakeFade * delta)

    offset = randomOffset()
