extends AnimatedSprite

func _ready():
	self.hide()

func talk(text):
	self.play("talk2")
	self.show()
	var start = randi()%(int($AudioStreamPlayer.stream.get_length()))
	$AudioStreamPlayer.play(start)
	$bubble/RichTextLabel.bbcode_text = "[center]" + text + "[/center]"


func _on_Enter_pressed():
	$AudioStreamPlayer.stop()
	self.stop()
	self.hide()	
