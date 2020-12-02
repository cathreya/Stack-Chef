extends Node2D

var CountDownValue = 0

func updateCountDown():
	$CountDown.text = str(CountDownValue)
	
#func _ready():
#	self.position = Vector2(200,200)
#	self.scale = Vector2(0.5, 0.5)
#	self.start(10)

func start(val):
	CountDownValue = val
	updateCountDown()
	$Timer.start()
	$AnimationPlayer.get_animation("Rotate").set_loop(true)
	$AnimationPlayer.play("Rotate")

func _on_Timer_timeout():
	CountDownValue -= 1
	updateCountDown()
	if CountDownValue <= 5:
		$AnimationPlayer.get_animation("Rotate_Flash").set_loop(true)
		$AnimationPlayer.play("Rotate_Flash")
	if CountDownValue == 0:
		$Timer.stop()
		$AnimationPlayer.stop()
		
