extends Sprite2D

signal harvested

const TARGET_POSITION := Vector2(239,350)
const MOVE_DURATION := 10.0

func _ready() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		self,
		"position",
		TARGET_POSITION,
		MOVE_DURATION
	)

	tween.finished.connect(_on_harvested)

func _on_harvested() -> void:
	harvested.emit()
	queue_free()
