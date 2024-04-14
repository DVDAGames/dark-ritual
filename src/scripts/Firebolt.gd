extends Area2D

var speed = Globals.tileSize * 5

func _process(delta):
  position += transform.x * speed * delta

func _ready():
  connect("body_entered", _on_Firebolt_body_entered)

func _on_Firebolt_body_entered(body):
  if body.is_in_group("effected_by_firebolt"):
    print('FLAMMABLE')
    if body.hit_by_firebolt != null:
      print('FIRE')
      body.hit_by_firebolt()
