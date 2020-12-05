extends AnimatedSprite

func _ready():
	randomize()
	$bubble.hide()
	$Enter.hide()

func talk(text):
	self.play("talk")
	var start = randi()%(int($AudioStreamPlayer.stream.get_length()))
	$AudioStreamPlayer.play(start)
	$bubble.show()
	$Enter.show()
	$bubble/RichTextLabel.bbcode_text = "[center]" + text + "[/center]"


func _on_Enter_pressed():
	self.stop()
	$AudioStreamPlayer.stop()
	$bubble.hide()	
	$Enter.hide()
