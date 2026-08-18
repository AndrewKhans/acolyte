extends CanvasLayer

@export var game_scene: String = "res://game.tscn"
@onready var face: TextureRect = $Face

func _ready() -> void:
	$Face.modulate.a = 0.0
	
	await get_tree().create_timer(1.0).timeout
	$IntroSound.play()
	await get_tree().create_timer(0.4).timeout

	await face_fade_in(5.0)
	await get_tree().create_timer(1.5).timeout
	await flicker(0.5)
	await get_tree().create_timer(0.3).timeout
	await fade_out(5)
	await get_tree().create_timer(1.5).timeout

	get_tree().change_scene_to_file(game_scene)
	
func face_fade_in(duration: float) -> void:
	var tween := create_tween()
	tween.tween_property(
		$Face,
		"modulate:a",
		0.5,
		duration*0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# Briefly flicker
	tween.tween_property($Face, "modulate:a", 0.15, 0.08)
	tween.tween_property($Face, "modulate:a", 0.5, 0.08)
	tween.tween_property($Face, "modulate:a", 0.15, 0.07)
	tween.tween_property($Face, "modulate:a", 0.6, 0.01)

	# Finally reveal the face
	tween.tween_property($Face, "modulate:a", 1.0, duration*0.5).set_trans(Tween.TRANS_SINE)
	
	await tween.finished


func flicker(duration: float = 3.0) -> void:
	var elapsed := 0.0

	while elapsed < duration:
		var tween := create_tween()

		# Same flicker pattern as the intro.
		tween.tween_property($Face,"modulate:a",0.15,0.08)
		tween.tween_property($Face,"modulate:a",0.5,0.08)
		tween.tween_property($Face,"modulate:a",0.25,0.07)
		tween.tween_property($Face,"modulate:a",1,0.07)

		await tween.finished

		## Random pause between flicker bursts.
		#var pause := randf_range(0.1, 0.5)
		#await get_tree().create_timer(pause).timeout

		elapsed += 0.5

	# End fully visible.
	var final_tween := create_tween()
	final_tween.tween_property($Face, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_SINE)

	await final_tween.finished

func fade_out(duration: float):
	var tween := create_tween()
	tween.set_parallel(false)

	tween.tween_property(face, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished
