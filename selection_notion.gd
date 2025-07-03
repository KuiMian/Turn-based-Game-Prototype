extends Sprite2D
class_name SelectionNotion

const OFFSET := Vector2(48, 0)

var working := false
var target_node: Node


func _process(delta: float) -> void:
	visible = working
	
	if working:
		position = target_node.global_position + OFFSET


func highlight(target: Node) -> void:
	target_node = target
	working = true


func unhighlight() -> void:
	target_node = null
	working = false
