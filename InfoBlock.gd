extends CanvasLayer
var gold = Color(249,198,0)
func draw(title, description, best_score, best_stars):
	$Panel/AnimationPlayer.play("blink")
	$Panel/Label.text = title
	$Panel/RichTextLabel.bbcode_text = "[center]" + description + "[/center]"
	$Panel/Score.text = "YOUR BEST SCORE: " + str(best_score)
	if best_stars >= 1:
		$Panel/star1.set_modulate(gold)
	if(best_stars >= 2):
		$Panel/star2.set_modulate(gold)
	if(best_stars >= 3):
		$Panel/star2.set_modulate(gold)
	
