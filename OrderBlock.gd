extends Area2D

var block_snapped = false
var item = ""
var time = 0
var serve_time = 0
signal correct_order(time_left)
signal incorrect_order
signal missed_order

func _ready():
	$Sprite.set_animation(item)
	$Clock.start(time)
	$AnimatedSprite.set_animation(str(randi()%3+1))
	
signal active_zero
func upd_active():
	get_parent().active -= 1
	emit_signal("active_zero")

func _on_Serve_pressed():
	if not block_snapped:
		return
	$Clock.stop()
	if block_snapped.value == item:
		var elapsed_time = time - $Clock.CountDownValue
		emit_signal("correct_order", elapsed_time)
		block_snapped.queue_free()
		upd_active()
		self.queue_free()
	else:
		emit_signal("incorrect_order")
	

func _on_Clock_timer_done():
	emit_signal("missed_order")
	upd_active()
	self.queue_free()
