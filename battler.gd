extends Sprite2D
class_name Battler

#@export var sprite :Texture2D

@export var is_player := false
@export var id := 'object'
@export var pos: Vector2

@export var speed := 1

@onready var area_2d: Area2D = $Area2D
@onready var global_pos: Marker2D = $GlobalPos
@onready var label: Label = $Label


func _ready() -> void:
	label.text = id
	
	if is_player:
		modulate = Color(1, 0, 1, 1)
		add_to_group("Player")
		area_2d.set_collision_layer_value(1, true)
		area_2d.set_collision_mask_value(2, true)
	else:
		modulate = Color(1, 1, 1, 1)
		add_to_group("Player")
		area_2d.set_collision_layer_value(2, true)
		area_2d.set_collision_mask_value(1, true)


func _process(delta: float) -> void:
	if not is_player:
		return
	
	self_modulate.a = sin(Time.get_ticks_msec() / 80.0) * 0.5 + 0.5


func init() -> void:
	set_process(false)
	self_modulate.a = 1.0


func play_turn(target: Battler) -> void:
	await attack_to(target)
	await move_back()


func attack_to(target: Battler) -> void:
	pos = global_position
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", target.global_position, 0.5)
	await t.finished


func move_back() -> void:
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", pos, 0.5)
	await t.finished





func hurt(_from: Battler) -> void:
	pass
