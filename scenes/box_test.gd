extends CharacterBody2D

const GRAVITY := 400

var should_apply_force := false
var y_force := 400
var gravity_scale := -1

var peak_pos = position.y
var portal_pos_y := 150.0
var target_peak_pos = null

func _process(delta: float) -> void:
	if position.y < peak_pos:
		peak_pos = position.y
	
		
func _physics_process(delta):
	#if Input.is_action_just_pressed("ui_jump") and is_on_floor():
	if should_apply_force:
		
		var portal_offset = abs(position.y- portal_pos_y)
		print("peak ", peak_pos)
		print("y_pos ",position.y)
		
		print("y_portal ", portal_pos_y)
		print("y_pos ",position.y)
		print("offset ",portal_offset)
		
		var distance = abs(peak_pos - position.y)
		print("peak_distance ", distance)
		distance += portal_offset
		print("peak_distance + offset ", distance )
		y_force = calculate_portal_force(distance)
		print("calculated_y_force ", y_force)
		target_peak_pos = peak_pos
		peak_pos = position.y
		
		
		velocity.y = y_force * gravity_scale
		should_apply_force = false
	
	# Apply gravity to the velocity
	velocity.y += GRAVITY * delta
	if target_peak_pos and (abs(position.y) - abs(target_peak_pos)) < 1:
	#if velocity.y < 10 and velocity.y > -10:
		#print("Stoping on peak")
		#print("vel ", velocity.y)
		#print("pos ", position.y)
		position.y = int(target_peak_pos)
		velocity.y = 0
		target_peak_pos = null
	move_and_slide()

func invert_gravity(base_y_pos: float) -> void:
	#up_direction *= -1
	#gravity_scale *= -1
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
	#
	
	
	
