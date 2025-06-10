extends Node2D

var is_closing = false 

var cat_video = preload("res://learnquanta/cat.ogv")
var meetq_video = preload("res://learnquanta/meetq.ogv")
var feeling_video = preload("res://learnquanta/feeling dizzy.ogv")
var nose_video = preload("res://learnquanta/nose bleed.ogv")
var probability_video = preload("res://learnquanta/probability.ogv")
var quantumscience_video = preload("res://learnquanta/quantum science.ogv")
var wave_video = preload("res://learnquanta/wave partical duality.ogv")

	
	

func _on_dizzy_pressed():
	$VideoWindow/VideoStreamPlayer.stream = feeling_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()
	
func _on_close_button_pressed():
	$VideoWindow.hide()
	$VideoWindow/VideoStreamPlayer.stop()


func _on_nose_pressed():
	$VideoWindow/VideoStreamPlayer.stream = nose_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()



func _on_wave_partical_pressed():
	$VideoWindow/VideoStreamPlayer.stream =wave_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()


func _on_quantum_pressed():
	$VideoWindow/VideoStreamPlayer.stream = quantumscience_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()


func _on_probability_pressed():
	$VideoWindow/VideoStreamPlayer.stream = probability_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()


func _on_cat_pressed():
	$VideoWindow/VideoStreamPlayer.stream = cat_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()


func _on_meet_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = meetq_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()


func _on_VideoStreamPlayer_finished() -> void:
	if not is_closing:
		$VideoWindow.hide()
		$VideoWindow/VideoStreamPlayer.stop()
	is_closing = false


func _on_video_window_close_requested():
	$VideoWindow.hide()
	$VideoWindow/VideoStreamPlayer.stop()


func _on_backbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://character_select/character_select.tscn")
