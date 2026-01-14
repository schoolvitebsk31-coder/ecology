extends TextureButton
var texture1 = preload("res://sprites/ilyfa toys/pluspsd.png")
var texture2 = preload("res://sprites/ilyfa toys/minus.png")



func _on_button_up() -> void:
	var window = get_window()
	if window.mode == Window.MODE_FULLSCREEN:
		window.mode = Window.MODE_WINDOWED 
		texture_normal = texture1
	else:
		window.mode = Window.MODE_FULLSCREEN
		texture_normal = texture2
