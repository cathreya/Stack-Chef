extends CanvasLayer

var score = 0
export var star1thresh = 0
export var star2thresh = 0
export var star3thresh = 0
export var level_name = "Level"

signal level_complete(score, stars)

var stars = 0
var gold = Color(249,198,0)
func draw():
	$Panel/Score.text = "SCORE: " + str(score)
	$Panel/star1lab.text = str(star1thresh)
	$Panel/star2lab.text = str(star2thresh)
	$Panel/star3lab.text = str(star3thresh)
	if(score >= star1thresh):
		$Panel/star1.set_modulate(gold)
		stars += 1
	else:
		$Panel/Label.text = "FAILURE"
	if(score >= star2thresh):
		$Panel/star2.set_modulate(gold)
		stars += 1
	if(score >= star2thresh):
		$Panel/star2.set_modulate(gold)
		stars += 1
	

func _ready():
	$Panel.hide()

func show(score):
	self.score = score
	$Panel.show()
	draw()


func _on_Enter_pressed():
	emit_signal("level_complete", score, stars)	
