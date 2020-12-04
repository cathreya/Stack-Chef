extends Area2D

var dragging = false

signal dragon;
signal dragoff;

export var isOperator = false
export var value = ""
var current = false

func update_text():
	$IngText.text = value
	if current:
		$AnimationPlayer.get_animation("flash").set_loop(true)
		$AnimationPlayer.play("flash")
	else:
		$AnimationPlayer.stop()
	if isOperator:
		$Sprite.modulate = Color(1.0, 0.5, 1.0)
	else:
		$Sprite.modulate = Color(1.0, 1.0, 1.0)

func _ready():
	connect("dragon",self,"_set_drag_on")
	connect("dragoff",self,"_set_drag_off")
	update_text()
	
func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)

func _set_drag_on():
	if not get_parent().clicked:
		dragging=true
		get_parent().clicked = true
func _set_drag_off():
	if dragging:
		get_parent().clicked = false
	dragging=false

func reparent1():
	var target = get_tree().get_root()
	self.get_parent().remove_child(self)
	target.add_child(self)
#	self.set_owner(target)

func reparent2():
	var target = get_tree().get_root().get_node("CanvasLayer")
	self.get_parent().remove_child(self)
	target.add_child(self)
#	self.set_owner(target)


var snapped_to = false
func _on_Block_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragon")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragoff")
			if snapped_to and snapped_to.name == "Trash":
				self.queue_free()
			elif snapped_to and not snapped_to.block_snapped:
				if not snapped_to.get_parent().get("in_use") :
					self.position = snapped_to.global_position
					snapped_to.block_snapped = self
					reparent1()
			
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index()	 == 0:
			self.position = event.get_position()
		

func snap(body):
	if snapped_to and snapped_to.name != "Trash" and snapped_to.block_snapped and snapped_to.block_snapped == self:
		snapped_to.block_snapped = false
	snapped_to = body

func unsnap(body):
#	if snapped_to and snapped_to.name != "Trash" and snapped_to.block_snapped and snapped_to.block_snapped == self:
#		snapped_to.block_snapped = false
#		snapped_to = false
#		reparent2()

	if snapped_to and snapped_to.block_snapped == body:
		if snapped_to.name != "Trash":
			snapped_to.block_snapped = false
		snapped_to = false
		reparent2()




