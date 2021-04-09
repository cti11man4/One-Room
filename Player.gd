extends KinematicBody

onready var camera = $RotationHelper/Camera
onready var rotation_helper = $RotationHelper

var gravity = -30
var max_speed = 8
var air_speed = .15
var mouse_sensitivity = 0.002  # radians/pixel
var jump = 10
var velocity = Vector3()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("ui_up"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("ui_down"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("ui_left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("ui_right"):
		input_dir += camera.global_transform.basis.x
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	input_dir = input_dir.normalized()
	return input_dir


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		rotation_helper.rotation.x = clamp(rotation_helper.rotation.x, -1.2, 1.2)


func _physics_process(delta):
	velocity.y += gravity * delta
	var input = get_input()
	var desired_velocity = input * max_speed
	var air_velocity = input * air_speed

	if is_on_floor():
		velocity.x = desired_velocity.x
		velocity.z = desired_velocity.z
	else:
		if not velocity.x >= max_speed:
			velocity.x += air_velocity.x
		if not velocity.z >= max_speed:
			velocity.z += air_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if Input.is_action_just_pressed("ui_select") && is_on_floor():
		velocity.y = jump


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
