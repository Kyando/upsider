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
		print("----")
		print("y_peak ", peak_pos)
		print("y_pos ", position.y)
		print("y_portal ", portal_pos_y)
		print("offset ", portal_offset)
		print("dist1 ", distance)
		if gravity_scale == -1:
			distance = abs(portal_pos_y - peak_pos)
		print("dist2 ", distance)
		distance += portal_offset
		print("dist3 ", distance)
	
		y_force = calculate_portal_force(distance)
		#y_force = 200 
		print("y_force ", y_force)
		
		var p_y = position.y
		target_peak_pos = position.y - (distance * gravity_scale)
		print("peak_pos ", peak_pos)
		print("target_pos ", target_peak_pos)
		peak_pos = position.y
		
		
		if gravity_scale == -1:
			velocity.y = y_force
		else:
			velocity.y = -y_force
		print("y_vel ", velocity.y)
		should_apply_force = false
	
	# Apply gravity to the velocity
	velocity.y += GRAVITY  * gravity_scale * delta
	
	
	if target_peak_pos: 
		var target_pos_dist = abs(abs(position.y) - abs(target_peak_pos))
		print("tartget_pos_dist ", target_pos_dist)
		if target_pos_dist < 3:
			print("Whaaat")
			var valuezinho = abs(abs(position.y) - abs(target_peak_pos))
			print("valuz: ",valuezinho)
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
	
	#print("Calculated portal Time: ", jump_time)
	#print("Calculated Portal Velocity: ", portal_velocity)
	return portal_velocity
	
	
	
