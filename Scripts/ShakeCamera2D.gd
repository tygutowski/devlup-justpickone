extends Camera2D

const TRANS := Tween.TRANS_SINE
const EASE := Tween.EASE_IN_OUT

var is_shaking := false 
var amplitude := 0

@onready var tween := create_tween()


func small_shake() -> void:
	_start(0.1, 12, 2)

func medium_shake() -> void:
	_start(0.1, 20, 12)

func _start(p_duration := 0.2, p_frequency := 15, p_amplitude := 16):
	if is_shaking:
		_on_duration_timeout()
	
	is_shaking = true
	
	amplitude = p_amplitude

	$Duration.wait_time = p_duration
	$Frequency.wait_time = p_duration / float(p_frequency)
	$Duration.start()
	$Frequency.start()

	_new_shake()

func _new_shake():
	var rand := Vector2(
		randf_range(-amplitude, amplitude),
		randf_range(-amplitude, amplitude)
	)
	

	var _tw = create_tween().tween_property(self, "offset", rand, $Frequency.wait_time)

func _reset():
	var _tw = create_tween().tween_property(self, "offset", Vector2.ZERO, $Frequency.wait_time)



func _on_duration_timeout():
	_reset()
	$Frequency.stop()
