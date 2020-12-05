extends Sprite

var cur = 1
func _ready():
	$Node2D/PlayerCam.current = true
	$Node2D/PlayerCam.set_position(Vector2(-984,-583))
	$Node2D/Path2D/PathFollow2D/AnimatedSprite.play("idle")
	$Node2D/Path2D/PathFollow2D.offset = 1

var disable = false
func _on_Right_pressed():
	if cur == 6 or disable:
		return
	disable = true
	$Node2D/AnimationPlayer.play(str(cur))
	$Node2D/Path2D/PathFollow2D/AnimatedSprite.play("walk")
	yield($Node2D/AnimationPlayer, "animation_finished")
	$Node2D/Path2D/PathFollow2D/AnimatedSprite.play("idle")
	$Node2D/Path2D/PathFollow2D.rotation_degrees = 0
	cur += 1
	disable = false


func _on_Left_pressed():
	if cur == 1 or disable:
		return
	disable = true
	cur -= 1
	$Node2D/Path2D/PathFollow2D/AnimatedSprite.play("back")
	$Node2D/AnimationPlayer.play_backwards(str(cur))
	yield($Node2D/AnimationPlayer, "animation_finished")
	$Node2D/Path2D/PathFollow2D/AnimatedSprite.play("idle")
	$Node2D/Path2D/PathFollow2D.rotation_degrees = 0
	disable = false

var levels = ["Tutorial: Post McFix's cakes and bakes", "Ford Loopez's assembly line Pizzeria", "¿Cómo \"¿cómo como??\" ¡Como como como!", "Sheikh Binary Salman's Garden of Desearthly Delights", "Polo Pierre Black's omelette du fromage", "Koi Keibyashi's noodle pagoda"]
var descriptions = [
	"Even the biggest of chefs need to start somewhere! Understand the basics of cooking with Chef Post McFix's help.",
	"Sometimes you want machines to take care of things so you don't have to bother. No, automation isn't taking your job, its just making your job easier.",
	"\"How do I eat? I eat like I eat!\" Your first real job! Can you handle these fine Mexican and South American dishes?",
	"A random tourist Sheikh was impressed by your cooking skills and invited you to work in his restaurant. He just heavily invested in a nobody, no pressure, right?",
	"In a bid to move up in the world you mail master chef Marco, err I mean Polo Pierre Black. To your surprise he lets you intern with him! Focus! You don't want to dissappoint one of the greats do you?",
	"Koi Keibayashi just won Japan its first 3 Michelin stars, and you get to work with him! Be careful! Wouldn't want to tarnish a newly formed reputation now would you."
]
var high_scores = [0,0,0,0,0]
var high_stars = [0,0,0,0,0]
var InfoClass = load("res://InfoBlock.tscn")
var popup = false

func upd_stars(points, stars):
	high_scores[cur-1] = max(high_scores[cur-1], points)
	high_stars[cur-1] = max(high_stars[cur-1], stars)

func _on_Enter_pressed():
	if disable:
		return
	if popup:
		var LevelClass = load("res://level"+str(cur)+".tscn")
		var par = get_parent()
		var level = LevelClass.instance()
		level.connect("level_complete", self, "upd_stars")
		par.remove_child(self)
		par.add_child(level)
		yield(level, "level_complete")
		par.remove_child(level)
		par.add_child(self)
		_on_Escape_pressed()
		return
		
	popup = true
	var ibox = InfoClass.instance()
	add_child(ibox)
	ibox.name = "infobox"
	ibox.draw(levels[cur-1], descriptions[cur-1], high_scores[cur-1], high_stars[cur-1])
	
	


func _on_Escape_pressed():
	print("here")
	if not popup:
		return
	popup = false
	get_node("infobox").queue_free()	
