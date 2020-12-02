extends Area2D

var dragging = false

signal dragon;
signal dragoff;

export var isOperator = false
export var value = ""

func update_text():
	$IngText.text = value
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
				self.position = snapped_to.global_position
				snapped_to.block_snapped = self
			
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index()	 == 0:
			self.position = event.get_position()
		

func snap(body):
	print("entered", body.name)
	if snapped_to and snapped_to.name != "Trash" and snapped_to.block_snapped and snapped_to.block_snapped == self:
		snapped_to.block_snapped = false
	snapped_to = body

func unsnap(body):
	print("exited", body.name)
	if snapped_to and snapped_to.name != "Trash" and snapped_to.block_snapped and snapped_to.block_snapped == self:
		snapped_to.block_snapped = false
		snapped_to = false




