@tool

class_name Sun

extends Body

func update_position(_delta: float):
	var collision = move_and_collide(velocity * _delta)
	if collision:
		crashed.emit(self, collision.get_collider() as Body)
