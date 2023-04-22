extends TileMap

#onready var tower = preload("res://Tower.tscn")
#@onready var interactible_cell = get_used_cells(1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#func _input(event):
#	if event.is_action_pressed("mouse1"):
#		var mouse_pos = get_viewport().get_mouse_position()
#		var tile_pos = (local_to_map(mouse_pos)) #Getting tile position from the mouse position
#		print(tile_pos)
#		print(get_cellv(tile_pos)) #Gets the tile index from the tile position
#		if get_cellv(tile_pos) == 1:
#			build(map_to_local(tile_pos))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
