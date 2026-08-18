extends Node2D

var big_guy = self
var big_guy_start_pos := position
var hover_time_min = 0
var hover_time_max = 0

func hover_speed(min, max) -> void:
	hover_time_min = min
	hover_time_max = max

func hover():
	var hover_distance := 1.0

	while true:
		# Pick a random nearby position
		var random_offset := Vector2(
			randf_range(-hover_distance, hover_distance),
			randf_range(-hover_distance, hover_distance)
		)

		var target_pos := big_guy_start_pos + random_offset
		var duration := randf_range(hover_time_min, hover_time_max)

		var tween := create_tween()
		tween.tween_property(
			big_guy,
			"position",
			target_pos,
			duration
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		await tween.finished

		## Small random pause before moving again
		#await get_tree().create_timer(
			#randf_range(hover_pause_min, hover_pause_max)
		#).timeout
