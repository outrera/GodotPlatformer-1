extends KinematicBody2D

const GRAVITY = 980
const SLIP = 2.25
const FLOORNORMAL = Vector2( 0, -1 )
const WALKSPEED = 250
const JUMPSTRENGTH = -500

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var Velocity = Vector2()
var grounded = false
var groundedHistory = false
var landedTimer = 0

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	
	groundedHistory = grounded
	Velocity.y += GRAVITY * delta
	
	move_and_slide( Velocity, FLOORNORMAL )
	var targetSpeed = 0
	if Input.is_action_pressed("ui_left"):
		targetSpeed = -1
	elif Input.is_action_pressed("ui_right"):
		targetSpeed = 1
	if Input.is_action_just_pressed("ui_select"):
		Velocity.y = JUMPSTRENGTH
		grounded = false
	targetSpeed *=  WALKSPEED
	
	if get_node("groundRay").is_colliding():
		grounded = true
	else:
		grounded = false
	
	if landedTimer > 0:
		landedTimer -= 1
	
	elif grounded:
		if !groundedHistory:
			Velocity.x = 0
			landedTimer = 5
		else:
			Velocity.x = lerp(Velocity.x, targetSpeed, 0.25)
			
	if abs(Velocity.x) < 1:
		Velocity.x = 0


func _ready():
	
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	
	print(Velocity.x)
	
	if Velocity.x < 0:
		sprite.flip_h = true
	elif Velocity.x > 0:
		sprite.flip_h = false
	
	if !grounded:
		if Velocity.y < 0:
			animationPlayer.play("jump")
		else:
			animationPlayer.play("falling")
	
	elif grounded:
		if !groundedHistory or landedTimer > 0:
			animationPlayer.play("landed")
		elif Velocity.x != 0:
			if animationPlayer.current_animation != "walk":
				animationPlayer.play("walk")
		else:
			animationPlayer.play("idle")
			
	pass
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
