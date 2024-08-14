extends Panel

@export_enum("Increase Player Speed", "Increase Player Life", "Increase XP Modifier",
	 "Increase Player Damage") var upgrade : int

@export_group("Percentage")
@export var is_percentage : bool
@export_range(1, 100) var percentage : int

@export_group("Quantity")
@export var is_quantity : bool
@export_range(1, 100) var quantity : int

var button : Button

var initial_scale : Vector2
var initial_z_index : int

var highlight : NinePatchRect

func _ready():
	highlight = Global.update_highlight_scene.instantiate()
	
	initial_z_index = z_index
	initial_scale = scale
	
	for child in get_children():
		if child is Button:
			button = child
			button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			button.pressed.connect(_button_pressed)
			button.mouse_entered.connect(_mouse_entered)
			button.mouse_exited.connect(_mouse_exited)
			
		elif child is RichTextLabel:
			child.bbcode_enabled = true
			var text = child.text
			child.clear()
			child.append_text(compile_text(text))

func _process(delta):
	if Global.is_paused():
		if Global.get_the_pause_caller() == Upgrades:
			button.disabled = false
		else:
			button.disabled = true

func compile_text(text : String) -> String:
	var regex := RegEx.new()
	
	if is_percentage:
		regex.compile("(\\[PERCENTAGE\\])")
		return regex.sub(text, str(percentage))
	elif is_quantity:
		regex.compile("\\[QUANTITY\\]")
		return regex.sub(text, str(quantity))
	return ""

func _button_pressed():
	if highlight.is_inside_tree():
		remove_child(highlight)
	Upgrades.choose_upgrade(upgrade, percentage, quantity)

func _mouse_entered():
	highlight = Global.update_highlight_scene.instantiate()
	if not highlight.is_inside_tree():
		add_child(highlight)
	z_index = 20
	scale *= 1.2

func _mouse_exited():
	if highlight.is_inside_tree():
		remove_child.call_deferred(highlight)
	z_index = initial_z_index
	scale = initial_scale
