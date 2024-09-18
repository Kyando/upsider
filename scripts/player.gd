extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -400.0
const GRAVITY_MULTIPLIER = 1.5
const MAX_Y_VELOCITY = 500

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var gravity_scale := 1
var rotating_speed := 12.0
var is_rotating = false
var y_offset = -6

var jump_peak_abs = 0
var gravity_force = 0


func _process(delta: float) -> void:
	if is_rotating:
		animated_sprite_2d.offset = Vector2(0, y_offset * gravity_scale)
		animated_sprite_2d.rotate(rotating_speed * delta)
	else:
		animated_sprite_2d.offset = Vector2.ZERO
		if gravity_scale == 1:
			animated_sprite_2d.rotation_degrees = 0
		else:
			animated_sprite_2d.rotation_degrees = 180
			animated_sprite_2d.offset = Vector2(0, y_offset * -gravity_scale)
	print(jump_peak_abs)

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		jump_peak_abs = 0
		is_rotating = false
	else: # Add the gravity.
		velocity += get_gravity( ) * gravity_scale * delta
		velocity = Vector2(velocity.x, clamp(velocity.y, -MAX_Y_VELOCITY, MAX_Y_VELOCITY))
		
		if abs(position.y) > jump_peak_abs:
			jump_peak_abs = position.y
			
	if gravity_force != 0:
		velocity.y = gravity_force * -gravity_scale * get_gravity().y * delta
		#gravity_force = 0
		
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * gravity_scale

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func invert_gravity() -> void:
	up_direction *= -1
	gravity_scale *= -1
	is_rotating = true
	jump_peak_abs = 0
	#gravity_force = abs(position.y - jump_peak_abs)
	
	
	
	
	
	
