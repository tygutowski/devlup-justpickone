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

func _start(duration := 0.2, frequency := 15, amplitude := 16):
	if is_shaking:
		_on_duration_timeout()
	
	print("SHAKING CAMERA")
	is_shaking = true
	
	self.amplitude = amplitude

	$Duration.wait_time = duration
	$Frequency.wait_time = duration / float(frequency)
	$Duration.start()
	$Frequency.start()

	_new_shake()

func _new_shake():
	print("NEW SHAKE")
	var rand := Vector2(
		randf_range(-amplitude, amplitude),
		randf_range(-amplitude, amplitude)
	)
	
	print(offset)
	create_tween().tween_property(self, "offset", rand, $Frequency.wait_time)
	print(offset)

func _reset():
	print("RESET")
	create_tween().tween_property(self, "offset", Vector2.ZERO, $Frequency.wait_time)


func _on_duration_timeout():
	_reset()
	$Frequency.stop()
