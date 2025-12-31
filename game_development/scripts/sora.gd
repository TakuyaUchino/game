extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
enum PlayerState {IDLE, WALK, RUN, JUMP, ATTACK}
@onready var sprite_anim: AnimatedSprite2D = $sprite_anim

var status: PlayerState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		PlayerState.IDLE:
			idle_state()
		PlayerState.WALK:
			walk_state()
		PlayerState.RUN:
			run_state()
		PlayerState.JUMP:
			jump_state()
		PlayerState.ATTACK:
			attack_state()
	
	move_and_slide()

func move():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, 40)
		velocity.x = direction * SPEED
		sprite_anim.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, 40)

func go_to_idle_state():
	status = PlayerState.IDLE
	sprite_anim.play("idle")	
	
func go_to_walk_state():
	status = PlayerState.WALK
	sprite_anim.play("walk")
	
func go_to_run_state():
	status = PlayerState.RUN
	sprite_anim.play("run")

func go_to_jump():
	status = PlayerState.JUMP
	sprite_anim.play("jump")
	velocity.y = JUMP_VELOCITY
	
func go_to_attack_state():
	status = PlayerState.ATTACK
	sprite_anim.play("combo_attack")
	await sprite_anim.animation_finished
	go_to_idle_state()

func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
	if Input.is_action_just_pressed("ui_up"):
		go_to_jump()
		return

func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("ui_up"):
		go_to_jump()
		return

func run_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("ui_up"):
		go_to_jump()
		return

func jump_state():
	move()
	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return

func attack_state():
	pass
