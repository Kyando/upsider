extends CharacterBody2D

class_name PlayerController

const SPEED = 200.0
const JUMP_VELOCITY = -380.0
const PLANAR_velocity = -150.0
const JUMP_BUFFER_TIME := 0.15 
const COYOTE_TIME := 0.15 

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D2

var rotating_speed := 12.0
var is_rotating = false
var y_offset = -10

var planar = false


# jump buffer
var jump_buffer_timer := 0.0 
var coyote_timer := 0.0 

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
		animated_sprite_2d.offset = Vector2(0, y_offset * -up_direction.y)
		animated_sprite_2d.rotate(rotating_speed * delta)
	else:
		animated_sprite_2d.offset = Vector2.ZERO
		if up_direction.y == -1:
			animated_sprite_2d.rotation_degrees = 0
		else:
			animated_sprite_2d.rotation_degrees = 180
			animated_sprite_2d.offset = Vector2(0, y_offset * up_direction.y)


func _physics_process(delta: float) -> void:
	
	$GravityEffect.process_physics(delta)
	var should_coyote_jump = coyote_timer  > 0.0
	var should_buffer_jump = is_on_floor() and jump_buffer_timer > 0.0

		
	if should_buffer_jump or (should_coyote_jump and Input.is_action_just_pressed("ui_accept")):
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
		velocity.y = JUMP_VELOCITY * -up_direction.y
		
	if Input.is_action_just_pressed("voo") and not is_on_floor():	
		velocity.y = PLANAR_velocity * -up_direction.y
		planar = true
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	if direction > 0:
		animated_sprite_2d.flip_h = false
	if direction < 0:	
		animated_sprite_2d.flip_h = true

	if is_on_floor():
		planar = false
		if not direction:
			animated_sprite_2d.play("Idle")
	if is_on_floor() and direction:
		animated_sprite_2d.play("Run")
	if not is_on_floor():
		animated_sprite_2d.play("Jump")	
	if is_on_floor():
		planar = false

	move_and_slide()


func invert_gravity(base_y_pos: float, apply_force: bool) -> void:
	$GravityEffect.invert_gravity(base_y_pos, apply_force)
