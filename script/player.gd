extends CharacterBody3D

const SPEED := 5.0
const MOUSE_SENS := 0.003
const GRAVITY := -9.8

var yaw := 0.0
var pitch := 0.0
var flashlight_on := true

var cam: Camera3D
var flashlight: SpotLight3D

func _ready():
	# Buscar los nodos de forma segura
	cam = get_node_or_null("Camera")
	if cam:
		flashlight = cam.get_node_or_null("Flashlight")
		if flashlight:
			print("Cámara y linterna encontradas")
		else:
			print("Advertencia: Linterna no encontrada")
	else:
		print("Error: Cámara no encontrada - Añade un nodo Camera3D como hijo del Player")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * MOUSE_SENS
		pitch = clamp(pitch - event.relative.y * MOUSE_SENS, -1.2, 1.2)
		rotation.y = yaw
		if cam:
			cam.rotation.x = pitch

	if event.is_action_pressed("toggle_flashlight") and flashlight:
		flashlight_on = not flashlight_on
		flashlight.visible = flashlight_on

func _physics_process(delta):
	var dir = Vector3.ZERO
	var fwd = -transform.basis.z
	var right = transform.basis.x

	if Input.is_action_pressed("move_forward"):
		dir += fwd
	if Input.is_action_pressed("move_back"):
		dir -= fwd
	if Input.is_action_pressed("move_left"):
		dir -= right
	if Input.is_action_pressed("move_right"):
		dir += right

	dir = dir.normalized()
	velocity.y += GRAVITY * delta
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED
	move_and_slide()
