extends CanvasLayer

var score = 0
export var star1thresh = 0
export var star2thresh = 0
export var star3thresh = 0
export var level_name = "Level"

signal stars(starts, level)

func draw():
	$Panel/Score.text = "SCORE: " + str(score)
	$Panel/star1lab.text = str(star1thresh)
	$Panel/star2lab.text = str(star2thresh)
	$Panel/star3lab.text = str(star3thresh)
	if(score >= star1thresh):
		$Panel/star1.set_modulate(Color(1,1,0))
	if(score >= star2thresh):
		$Panel/star2.set_modulate(Color(1,1,0))
	if(score >= star2thresh):
		$Panel/star2.set_modulate(Color(1,1,0))
	

func _ready():
	$Panel.hide()

func show(score):
	self.score = score
	$Panel.show()
	draw()
