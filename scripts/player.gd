extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -250.0
#const GRAVITY_MULTIPLIER = 1.5
#const MAX_Y_VELOCITY = 500
const GRAVITY := 600

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var gravity_scale := 1
var rotating_speed := 12.0
var is_rotating = false
var y_offset = -6

#var jump_peak_abs = 0
#var gravity_force = 0

var y_force := 400
var should_apply_force := false
var portal_pos_y := 150.0
var peak_pos = null
var target_peak_pos = null


func _ready() -> void:
	peak_pos = position.y
	print("x ", position.x)
	print("y ", position.y)
	print("peak_pos ", peak_pos)

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
			
	if gravity_scale == 1:
		if position.y < peak_pos:
			peak_pos = position.y
	elif gravity_scale == -1:
		if peak_pos < position.y :
			peak_pos = position.y

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		is_rotating = false
	else: # Add the gravity.
		if should_apply_force:
			var portal_offset = abs(position.y- portal_pos_y)
			var distance = abs(peak_pos - portal_pos_y)
			if gravity_scale == -1:
				distance = abs(portal_pos_y - peak_pos)
			distance += portal_offset
			y_force = calculate_portal_force(distance)
			
			var p_y = position.y
			target_peak_pos = position.y - (distance * gravity_scale)
			peak_pos = position.y
			
			
			if gravity_scale == -1:
				velocity.y = y_force
			else:
				velocity.y = -y_force
			should_apply_force = false
		
		# Apply gravity to the velocity
		velocity.y += GRAVITY  * gravity_scale * delta
		
		
		if target_peak_pos: 
			var target_pos_dist = abs(abs(position.y) - abs(target_peak_pos))
			if target_pos_dist < 3:
				var valuezinho = abs(abs(position.y) - abs(target_peak_pos))
				position.y = int(target_peak_pos)
				velocity.y = 0
				target_peak_pos = null
			
		#move_and_slide()
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * gravity_scale
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func invert_gravity(base_y_pos: float) -> void:
	up_direction *= -1
	gravity_scale *= -1
	portal_pos_y = base_y_pos
	should_apply_force = true
	

func calculate_portal_force(distance):
	# Calculate jump_time based on gravity and peak height
	var jump_time = 2.0 * sqrt((2.0 * distance) / GRAVITY)
	
	# Calculate jump velocity based on the newly calculated jump_time
	var portal_velocity = GRAVITY * (jump_time / 2)
	
	return portal_velocity
	
