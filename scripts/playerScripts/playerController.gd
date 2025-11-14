extends CharacterBody2D

@export var speed:float = 50.0
@onready var anim_tree:AnimationTree = get_node("AnimationTree")

func _physics_process(_delta):
	var input_vec = Input.get_vector("left", "right", "up", "down")
	velocity = input_vec * speed
	
	if input_vec == Vector2.ZERO:
		anim_tree.get("parameters/playback").travel("Idle")
	else:
		anim_tree.get("parameters/playback").travel("Walk")
		anim_tree.set("parameters/Idle/BlendSpace2D/blend_position", input_vec)
		anim_tree.set("parameters/Walk/BlendSpace2D/blend_position", input_vec)
		anim_tree.set("parameters/Attack/BlendSpace2D/blend_position", input_vec)
	
	move_and_slide()
