extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -250.0
const GRAVITY := 600
const JUMP_BUFFER_TIME := 0.15 
const COYOTE_TIME := 0.15 

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var available_portal_distances := [60.0, 75.0,85.0, 100.0]

var gravity_scale := 1
var rotating_speed := 12.0
var is_rotating = false
var y_offset = -6


var y_force := 400
var should_apply_force := false
var portal_pos_y = null
var peak_pos = null
var target_peak_pos = null

# jump buffer

var jump_buffer_timer := 0.0 
var coyote_timer := 0.0 


func _ready() -> void:
	peak_pos = position.y

func _process(delta: float) -> void:
	
#	Jump Buffer
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta 
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME 
		
#	Coyote Timer
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
	
#	Rotating
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
			

#	Update Peak position
	if gravity_scale == 1:
		if position.y < peak_pos:
			peak_pos = position.y
	elif gravity_scale == -1:
		if peak_pos < position.y :
			peak_pos = position.y
	

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		is_rotating = false
		peak_pos = position.y
		target_peak_pos = null
	else: # Add the gravity.
		if should_apply_force:
			var portal_offset = position.y- portal_pos_y
			var portal_direction = portal_offset / abs(portal_offset)
			portal_offset = abs(portal_offset)
			var distance = abs(peak_pos - portal_pos_y)
			if gravity_scale == -1:
				distance = abs(portal_pos_y - peak_pos)
				
			if gravity_scale * portal_direction == 1:
				distance = get_closest_available_dist_force(distance)
				distance += portal_offset
				
				y_force = calculate_portal_force(distance)
			else:
				y_force = 10
			
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
			
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var should_coyote_jump = coyote_timer  > 0.0
	var should_buffer_jump = is_on_floor() and jump_buffer_timer > 0.0

		
	if should_buffer_jump or (should_coyote_jump and Input.is_action_just_pressed("ui_accept")):
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
		velocity.y = JUMP_VELOCITY * gravity_scale
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func get_closest_available_dist_force(dist: float) -> float:
	var closest_dist = available_portal_distances[0]
	var min_diff = abs(closest_dist - dist)
	
	for value in available_portal_distances:
		var diff = abs(value - dist)
		if diff < min_diff:
			min_diff = diff
			closest_dist = value
	
	return closest_dist
	
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
	
