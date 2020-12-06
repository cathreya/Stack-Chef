extends CanvasLayer

signal scene_changed

onready var animation_player = $AnimationPlayer
onready var black = $Control/ColorRect

func _ready():
	$Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Control/ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	 
func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay),"timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	var ret = get_tree().change_scene(path)
	assert(ret == OK)
	animation_player.play_backwards("fade") 
	emit_signal("scene_changed")
