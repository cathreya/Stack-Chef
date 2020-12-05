extends Area2D

var dragging = false

signal dragon;
signal dragoff;

export var isOperator = false
export var value = ""

var current = false

var sounds

func update_text():
	if not "+" in value:
		$Sprite.set_animation(value)
	else:
		$Sprite.set_animation("Intermediate")
	if current:
		$AnimationPlayer.get_animation("flash").set_loop(true)
		$AnimationPlayer.play("flash")
#		sounds[value].play()
	else:
		$AnimationPlayer.stop()

func _ready():
	$Sprite.set_animation(value)
	sounds = {"Mix": $blend, "Chop":$chop, "Blend":$blend, "Bake":$bake}
	connect("dragon",self,"_set_drag_on")
	connect("dragoff",self,"_set_drag_off")
	update_text()

var snapped_to = false

func _process(delta):
	if dragging and (not snapped_to or not snapped_to.get_parent().get("in_use")) :
		#var mousepos = get_viewport().get_mouse_position()
		var mousepos = get_global_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)

func _set_drag_on():
	$chess.play()
	if not get_parent().clicked:
		dragging=true
		get_parent().clicked = true
func _set_drag_off():
	$chess2.play()
	if dragging:
		get_parent().clicked = false
	dragging=false

func reparent():
	print("reparented")
	var target = get_tree().get_root().get_node("Level")
	self.get_parent().remove_child(self)
	target.add_child(self)
#	self.set_owner(target)

func _on_Block_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if self.get_parent().name == "CanvasLayer":
			reparent()
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

	if snapped_to and snapped_to == body:
		if snapped_to.name != "Trash" and snapped_to.block_snapped and snapped_to.block_snapped == self:
			snapped_to.block_snapped = false
		snapped_to = false




