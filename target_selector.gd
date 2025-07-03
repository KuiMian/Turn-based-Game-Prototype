extends Area2D
class_name TargetSelector


signal selected_target(target: Battler)
signal hover_target
signal cancel_hover_target

@onready var colli: CollisionShape2D = $Colli

var working := false
var target: Battler


func _ready() -> void:
	add_to_group("mouse")
	
	area_entered.connect(_on_mouse_enter)
	area_exited.connect(_on_mouse_exit)


func _process(delta: float) -> void:
	global_position = get_global_mouse_position()


func start() -> void:
	set_collision_mask_value(2, true)


func end() -> void:
	set_collision_mask_value(2, false)


func choose_target():
	target = await selected_target
	return target


func _on_mouse_enter(body: Node) -> void:
	working = true
	hover_target.emit(body.owner)
	target = body.owner


func _on_mouse_exit(_body: Node) -> void:
	target = null
	working = false
	cancel_hover_target.emit()




func _input(event: InputEvent) -> void:
	if working:
		if event.is_action_pressed("left_click"):
			selected_target.emit(target)
