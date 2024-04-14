extends Area2D

var speed = Globals.tileSize

func _process(delta):
  position += transform.x * speed * 2 * delta

func _on_Firebolt_body_entered(body):
  if body.is_in_group("effected_by_firebolt"):
    if body.hit_by_firebolt != null:
      body.hit_by_firebolt()
