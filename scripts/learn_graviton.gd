extends Node2D
var is_closing = false 

var orbits_video = preload("res://learngraviton/orbit.ogv")
var meet_graviton_video = preload("res://learngraviton/meet.ogv")
var bleed_video = preload("res://learngraviton/bleed.ogv")
var burn_video = preload("res://learngraviton/burn.ogv")
var gravity_bends_video = preload("res://learngraviton/gravity bends.ogv")
var heavily_video = preload("res://learngraviton/heavily.ogv")
var nothing_can_escape_video = preload("res://learngraviton/nothingcanescape.ogv")
var time_different_video = preload("res://learngraviton/time different.ogv")
var why_choose_video = preload("res://learngraviton/why choose.ogv")

func _on_orbit_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = orbits_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

func _on_meet_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = meet_graviton_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

func _on_bleed_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = bleed_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

func _on_burn_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = burn_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

func _on_gravitybends_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = gravity_bends_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

func _on_heavily_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = heavily_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

func _on_nothing_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = nothing_can_escape_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

func _on_timeis_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = time_different_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

func _on_why_button_pressed():
	$VideoWindow/VideoStreamPlayer.stream = why_choose_video
	$VideoWindow.show()
	$VideoWindow/VideoStreamPlayer.play()

	

func _on_VideoStreamPlayer_finished():
	if not is_closing:
		$VideoWindow.hide()
		$VideoWindow/VideoStreamPlayer.stop()
	is_closing = false
	




func _on_video_window_close_requested():
	$VideoWindow.hide()
	$VideoWindow/VideoStreamPlayer.stop()


func _on_backbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://character_select/character_select.tscn")
