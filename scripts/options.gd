# Options.gd
extends Control

func _ready() -> void:
	$btn_back.pressed.connect(Callable(self, "_on_btn_back_pressed"))

func _on_btn_back_pressed() -> void:
	get_tree().change_scene_to(preload("res://scenes/main_menu.tscn"))
