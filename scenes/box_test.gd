extends CharacterBody2D

const GRAVITY := 400

var should_apply_force := false
var y_force := 400
var gravity_scale := 1

var peak_pos = position.y
var portal_pos_y := 150.0
var target_peak_pos = null

func _process(delta: float) -> void:
	if gravity_scale == 1:
		if position.y < peak_pos:
			peak_pos = position.y
	elif gravity_scale == -1:
		if peak_pos < position.y :
			peak_pos = position.y
	
		
func _physics_process(delta):
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
		
	move_and_slide()

func invert_gravity(base_y_pos: float) -> void:
	#up_direction *= -1
	gravity_scale *= -1
	portal_pos_y = base_y_pos
	should_apply_force = true
	
	
func calculate_portal_force(distance):
	# Calculate jump_time based on gravity and peak height
	var jump_time = 2.0 * sqrt((2.0 * distance) / GRAVITY)
	
	# Calculate jump velocity based on the newly calculated jump_time
	var portal_velocity = GRAVITY * (jump_time / 2)
	
	return portal_velocity
	
	
	
