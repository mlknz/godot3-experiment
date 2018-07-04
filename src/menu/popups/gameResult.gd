extends PopupDialog

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("ToMenuButton").connect("pressed", self, "_to_main_menu")
	get_node("StartAgainButton").connect("pressed", self, "_start_again")
	pass

func _to_main_menu():
	get_node("/root/global").goto_scene("res://src/menu/main_menu.tscn")
	pass

func _start_again():
	get_node("/root/global").goto_scene("res://src/game/gamescene.tscn")
	pass
