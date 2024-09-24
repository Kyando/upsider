extends Node
class_name GravityEffect


const GRAVITY := 600
const MAX_FALL_SPEED := 300   

#@export var available_portal_distances := [20.0, 50.0, 85.0, 100.0]
@export var available_portal_distances := [38.0,  55.0, 82.0, 98.0 ]
@export var velocity_distance_map := {
	0: 38.0,
	260: 55.0,
	295: 82.0,
	380: 98.0
}
@export var body : CharacterBody2D

var fall_speed_multiplier := 2
var gravity_scale := 1
var rotating_speed := 12.0
var is_rotating = false
var y_offset = -6

var y_force := 400
var should_apply_force := false
var portal_pos_y = null
var peak_pos = null

func _ready() -> void:
	body = get_parent() as CharacterBody2D
	peak_pos = body.position.y
	
	
func _process(delta: float) -> void:
	#Update Peak position
	if gravity_scale == 1:
		if body.position.y < peak_pos :
			peak_pos = body.position.y
	elif gravity_scale == -1:
		if peak_pos < body.position.y :
			peak_pos = body.position.y 


func process_physics(delta: float) -> void:
	if not body.is_on_floor():
		if should_apply_force:
			print("---")
			print("pos_y ", body.position.y)
			print("pposy ", portal_pos_y)
			var portal_offset = body.position.y- portal_pos_y
			portal_offset = abs(portal_offset )
			print("offst ", portal_offset)
			var portal_direction = -body.velocity.y / abs(body.velocity.y)

			var distance = abs(peak_pos - portal_pos_y)
			if gravity_scale == -1:
				distance = abs(portal_pos_y - peak_pos)
			
			if gravity_scale * portal_direction == 1:
				#distance = get_closest_available_dist_force(distance)
				distance = get_dist_force_from_velocity(body.velocity.y)
				#distance += portal_offset
				print("dist ", distance)
				var target_peak = body.position.y + (-1 * portal_direction * portal_offset) + distance
				print("targt ", target_peak)
				var peak_dist = abs(target_peak - portal_pos_y) 
				print("peak_d ", peak_dist)
				var p_peak_dist = abs(target_peak - body.position.y) 
				print("peak_p ", p_peak_dist)
			
				
				y_force = calculate_portal_force(distance)
			else:
				y_force = 10
			
			peak_pos = body.position.y
			
			if gravity_scale == -1:
				body.velocity.y = y_force
			else:
				body.velocity.y = -y_force
			should_apply_force = false
		
		# Apply gravity to the velocity
		var fall_multiplier = 1
		if (gravity_scale == 1 and body.velocity.y > 0) or \
		(gravity_scale == -1 and body.velocity.y < 0):
			fall_multiplier = fall_speed_multiplier
		
		body.velocity.y += GRAVITY  * gravity_scale * fall_multiplier * delta
		#body.velocity.y = clamp(body.velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)
		



func get_dist_force_from_velocity(y_velocity: float) -> float:
	var output_dist := 0.0
	var y_vel = abs(y_velocity)
	for key_vel in velocity_distance_map:
		if y_vel >= key_vel:
			output_dist = velocity_distance_map[key_vel]
	
	return output_dist
	
func get_closest_available_dist_force(dist: float) -> float:
	var closest_dist = available_portal_distances[0]
	var min_diff = abs(closest_dist - dist)
	
	for value in available_portal_distances:
		var diff = abs(value - dist)
		if diff < min_diff and dist >= value:
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
	
