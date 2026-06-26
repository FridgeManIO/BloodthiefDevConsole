extends "res://addons/ModLoader/mod_node.gd"

var custom_console = preload("custom_console.tscn")
var console_node = custom_console.instantiate()

var text_node_path = "CenterContainer/TextEdit"


var resume_time_scale = 1.0
var hud_hidden = false

var previous_commands = []


func init():
	ModLoader.mod_log(name_pretty + " mod loaded")
	settings = {
		"settings_page_name" = "Mod Awareness Enabled",
		"settings_list" = [

			]
		}

	console_node.set_focus_mode(1)

func console_display_unshaded(args):

	if not len(args) >= 1:
		return false

	var draw_mode = args[0]

	if draw_mode.to_lower() == "disabled" or draw_mode.to_lower() == "normal":
		get_viewport().set_debug_draw(Viewport.DebugDraw.DEBUG_DRAW_DISABLED)
	elif draw_mode.to_lower() == "unshaded":
		get_viewport().set_debug_draw(Viewport.DebugDraw.DEBUG_DRAW_UNSHADED)
	elif draw_mode.to_lower() == "overdraw":
		get_viewport().set_debug_draw(Viewport.DebugDraw.DEBUG_DRAW_OVERDRAW)
	elif draw_mode.to_lower() == "shadowatlas":
		get_viewport().set_debug_draw(Viewport.DebugDraw.DEBUG_DRAW_DIRECTIONAL_SHADOW_ATLAS)
	elif draw_mode.to_lower() == "normalbuffer":
		get_viewport().set_debug_draw(Viewport.DebugDraw.DEBUG_DRAW_NORMAL_BUFFER)
	elif draw_mode.to_lower() == "ocbuffer":
		get_viewport().set_debug_draw(Viewport.DebugDraw.DEBUG_DRAW_OCCLUDERS)
	elif draw_mode.to_lower() == "wireframe":
		get_viewport().set_debug_draw(Viewport.DebugDraw.DEBUG_DRAW_WIREFRAME)
	elif draw_mode.to_lower() == "lighting":
		get_viewport().set_debug_draw(Viewport.DebugDraw.DEBUG_DRAW_LIGHTING)

	return true

var in_freecam = false #bad way of doing this - fix.
func noclip(_args):
	# print(previous_state)
	if in_freecam:
		in_freecam = false
		GameManager.player.change_states(GameManager.player.in_air_state.name, GameManager.player, null)
	else:
		previous_state = GameManager.player.current_state_name
		in_freecam = true
		GameManager.player.change_states(GameManager.player.free_cam_state.name, GameManager.player, null)
	
	return true

var savedata = [] 
func savestate(_args):
	# Saves current checkpoint of player and their position, orientation. Loads at the relevant datapoints.
	self.savedata = [
		GameManager.current_checkpoint,
		GameManager.get_player().position,
		GameManager.get_player().rotation,
		GameManager.get_player().blood_amount,
		GameManager.get_player().god_blood_amount,
		GameManager.get_player().velocity,
		GameManager.get_player().current_state_name
	]

	# ATM state defaults to the do nothing state from the console, doesn't actually do anything

	# TODO: Ensure state is cleared on level change.
	pass

func loadstate(_args):
	#Calls set checkpoint + move to teleport player to desired position!

	if len(savedata) == 0:
		return

	GameManager.current_checkpoint = savedata[0]
	GameManager.get_player().position = savedata[1]
	GameManager.get_player().rotation = savedata[2]
	GameManager.get_player().blood_amount = savedata[3]
	GameManager.get_player().god_blood_amount = savedata[4]
	GameManager.get_player().velocity = savedata[5]
	GameManager.get_player().change_states(savedata[6].name,GameManager.get_player(),null)

func infblood(_args):
	GameManager.player.is_unlimited_blood_powerup_active = not GameManager.player.is_unlimited_blood_powerup_active

var god_mode_on = false
func toggle_god_mode(_args):
	GameManager.player.is_unlimited_blood_powerup_active = not GameManager.player.is_unlimited_blood_powerup_active
	return
	if god_mode_on:
		GameManager.player.hurt_collider.set_deferred("enabled", true)
		# GameManager.player.main_collider.set_deferred("enabled", true)
		god_mode_on = false
	else:
		GameManager.player.hurt_collider.set_deferred("disabled", true)
		# GameManager.player.main_collider.set_deferred("disabled", true)
		god_mode_on = true
	return true

func toggle_player_model(_args):
	GameManager.player.visible = not GameManager.player.visible 

func toggle_hud(_args):
	var p: Player = GameManager.get_player()

	var alpha: float = 1 if hud_hidden else 0
	for node in [p.get_node("CanvasLayer/VelocityDisplay"),
			p.get_node("CanvasLayer/JumpCountBar"), 
			p.get_node("CanvasLayer/Bloodbar"), 
			p.get_node("CanvasLayer/ItemDock"), 
			p.get_node("CanvasLayer/AirDashCrossHair"), 
			p.get_node("CanvasLayer/Reticle")]:
		node.modulate.a = alpha
		node.visible = hud_hidden
	
	hud_hidden = not hud_hidden

func kill(_args):
	pass

func deaggro(_args):
	pass

func move(args):
	
	if not len(args) >= 3:
		return false
	
	var x := float(args[0])
	var y := float(args[1])
	var z := float(args[2])

	GameManager.player.position += Vector3(x,y,z)

func set_checkpoint(args):
	if not len(args) >= 1:
		return false
	GameManager.current_checkpoint = int(args[0])
	GameManager.quick_restart()

func help(_args):
	Signals.toast.emit(ToastController.Toast.player_closed("""var valid_commands = {
	"infblood":infblood,
	"tgm":toggle_god_mode,
	"reshade": console_display_unshaded,
	"tcl":noclip,
	"timescale":set_time_scale,
	"ts":set_time_scale,
	"toggle_model":toggle_player_model,
	"toggle_hud":toggle_hud,
	"move":move,
	"mv":move,
	"setcpoint":set_checkpoint,
	"c":set_checkpoint,
	"help":help,
	"save":savestate,
	"load":loadstate
}"""))

var valid_commands = {
	"infblood":infblood,
	"tgm":toggle_god_mode,
	"reshade": console_display_unshaded,
	"tcl":noclip,
	"timescale":set_time_scale,
	"ts":set_time_scale,
	"toggle_model":toggle_player_model,
	"toggle_hud":toggle_hud,
	"move":move,
	"mv":move,
	"setcpoint":set_checkpoint,
	"c":set_checkpoint,
	"help":help,
	"save":savestate,
	"load":loadstate
}

func set_time_scale(args):
	resume_time_scale = float(args[0])


var node_added = false
var console_enabled = false
var console_focus_just_pressed = false
var previous_state = GameManager.player.current_state_name

func execute_command(text:String):
	text = text.replace("\n","")
	
	var command_array = text.split(" ")
	
	var command = ""
	var args = []

	previous_commands.append(text)

	for part in command_array:
		if part == "":
			continue
		
		if command == "":
			command = part

		else:
			args.append(part)

	if command in valid_commands.keys():
		print(valid_commands.get(command).call(args))

func query_attach_console():
	if !is_instance_valid(GameManager.player):
		return false

	var canvas := GameManager.player.get_node_or_null("CanvasLayer")
	if canvas == null:
		print("Player has no CanvasLayer.")
		return false

	if canvas.has_node("CustomConsole"):
		return true

	console_node = custom_console.instantiate()
	GameManager.player.get_node("CanvasLayer").add_child(console_node)
	console_node.visible = false
	print("Console attached.")
	return true

func _process(delta):

	if !query_attach_console():
		return

	if Input.is_key_pressed(KEY_QUOTELEFT):
		if console_focus_just_pressed: 
			return
		
		console_enabled = not console_enabled
		console_focus_just_pressed = true
	else:
		console_focus_just_pressed = false

	if Input.is_key_pressed(KEY_ENTER):
		if console_enabled:
			execute_command(console_node.get_node(text_node_path).get_text())
			console_enabled = false
			console_focus_just_pressed = true

	if console_enabled:
		console_node.visible = true
		GameManager.player.change_states(GameManager.player.do_nothing_state.name, GameManager.player)
		console_node.get_node(text_node_path).grab_focus()
		Engine.time_scale = 0.0

		if Input.is_action_just_pressed("menu_up"):

			var prev_command = previous_commands.back()

			console_node.get_node(text_node_path).set_text(prev_command)
			console_node.get_node(text_node_path).set_caret_column(len(prev_command))
		elif Input.is_action_just_pressed("menu_down"):
			console_node.get_node(text_node_path).set_text("")


	elif not console_enabled and console_focus_just_pressed:
		console_node.visible = false
		if not in_freecam:
			GameManager.player.change_states(GameManager.player.in_air_state.name, GameManager.player, null)
		console_node.get_node(text_node_path).set_text("")
		Engine.time_scale = resume_time_scale

	else:
		Engine.time_scale = resume_time_scale
