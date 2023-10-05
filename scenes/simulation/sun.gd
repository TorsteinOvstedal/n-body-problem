@tool

class_name Sun

extends Body

func update_position(_delta: float):
	move_and_collide(velocity * _delta)
