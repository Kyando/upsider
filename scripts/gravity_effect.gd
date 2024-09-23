class_name GravityEffect
extends Node

const GRAVITY := 600

@export var available_portal_distances := [40.0, 60.0, 75.0,85.0, 100.0]
@export var body : CharacterBody2D

var gravity_scale := 1
var rotating_speed := 12.0
var is_rotating = false
var y_offset = -6


var y_force := 400
var should_apply_force := false
var portal_pos_y = null
var peak_pos = null
var target_peak_pos = null

func _ready() -> void:
	body = get_parent() as CharacterBody2D
	peak_pos = body.position.y
	
	
func _process(delta: float) -> void:
#	Update Peak position
	if gravity_scale == 1:
		if body.position.y < peak_pos:
			peak_pos = body.position.y
	elif gravity_scale == -1:
		if peak_pos < body.position.y :
			peak_pos = body.position.y 


func _physics_process(delta: float) -> void:
	if body.is_on_floor():
		peak_pos = body.position.y
		target_peak_pos = null
	else: # Add the gravity.
		if should_apply_force:
			var portal_offset = body.position.y- portal_pos_y
			#var portal_direction = portal_offset / abs(portal_offset)
			var portal_direction = -body.velocity.y / abs(body.velocity.y)
			portal_offset = abs(portal_offset )
			var distance = abs(peak_pos - portal_pos_y)
			if gravity_scale == -1:
				distance = abs(portal_pos_y - peak_pos)
			
			print("Portal Direction ", portal_direction)
			if gravity_scale * portal_direction == 1:
				distance = get_closest_available_dist_force(distance)
				distance += portal_offset
				
				y_force = calculate_portal_force(distance)
			else:
				y_force = 10
			
			var p_y = body.position.y
			target_peak_pos = body.position.y - (distance * gravity_scale)
			peak_pos = body.position.y
			
			
			if gravity_scale == -1:
				body.velocity.y = y_force
			else:
				body.velocity.y = -y_force
			should_apply_force = false
		
		# Apply gravity to the velocity
		body.velocity.y += GRAVITY  * gravity_scale * delta
		
		
		if target_peak_pos: 
			var target_pos_dist = abs(abs(body.position.y) - abs(target_peak_pos))
			if target_pos_dist < 3:
				var valuezinho = abs(abs(body.position.y) - abs(target_peak_pos))
				body.position.y = int(target_peak_pos)
				body.velocity.y =  0
				target_peak_pos = null
			
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	

	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
	

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
	body.up_direction *= -1
	gravity_scale *= -1
	portal_pos_y = base_y_pos
	should_apply_force = true
	

func calculate_portal_force(distance):
	# Calculate jump_time based on gravity and peak height
	var jump_time = 2.0 * sqrt((2.0 * distance) / GRAVITY)
	# Calculate jump velocity based on the newly calculated jump_time
	var portal_velocity = GRAVITY * (jump_time / 2)
	
	return portal_velocity
	
