extends Node2D


@export var battlers: Array[Battler]
@export var players: Array[Battler]
@export var enemies: Array[Battler]
@export var turn_queue: Node2D

@onready var target_selector: TargetSelector = $UI/TargetSelector
@onready var selection_notion: SelectionNotion = $UI/SelectionNotion



func _ready() -> void:
	target_selector.hover_target.connect(show_selection_notion)
	target_selector.cancel_hover_target.connect(hide_selection_notion)
	
	turn_queue = $TurnQueue
	
	init_units()


func init_units() -> void:
	battlers = []
	players = []
	enemies = []
	
	for child in turn_queue.get_children():
		#battlers = turn_queue.get_children()
		if child is Battler:
			battlers.append(child)
	
	for battler in battlers:
		if battler.is_player:
			players.append(battler)
		else:
			enemies.append(battler)

	var P_pos = get_node("PlayerPos").get_children() as Array[Marker2D]
	var E_pos = get_node("EnemyPos").get_children() as Array[Marker2D]
	
	var index := 0
	for player in players:
		player.init()
		player.global_position = P_pos[index].global_position
		index += 1
	
	index = 0
	for enemy in enemies:
		enemy.init()
		enemy.global_position = E_pos[index].global_position
		index += 1
	
	battlers.sort_custom(
		func(a: Battler, b: Battler):
			return a.speed > b.speed
	)
	
	play_turn()


func play_turn() -> void:
	if players.size() <= 0:
		lose()
		return
	
	if enemies.size() <= 0:
		win()
		return 
		
	var target: Battler
	for battler in battlers:
		battler.move_to_front()
		
		if battler.is_player:
			target_selector.start()
			battler.set_process(true)
			target = await target_selector.choose_target()
			target_selector.end()
			battler.set_process(false)
			battler.self_modulate.a = 1.0
			
			await battler.play_turn(target)
		else:
			target = players.pick_random()
			await battler.play_turn(target)
		
		await get_tree().create_timer(0.2).timeout
	
	if enemies.size() > 0 and players.size() > 0:
		init_units()


func show_selection_notion(target: Battler) -> void:
	if target.is_player: 
		return
	
	selection_notion.highlight(target)


func hide_selection_notion() -> void:
	selection_notion.unhighlight()









func lose() -> void:
	pass


func win() -> void:
	pass
