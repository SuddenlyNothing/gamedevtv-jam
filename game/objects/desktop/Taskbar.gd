tool
extends Control

const FolderButton := preload("res://objects/desktop/Folder.tscn")
const TxtButton := preload("res://objects/desktop/Txt.tscn")

export var folder_data: Resource

var running_programs := {}
var app_programs := {}
var apps_to_buttons := {}

onready var apps_parent := $"%AppsParent"
onready var time := $"%Time"
onready var desktop := $V/Desktop


func _ready() -> void:
	if Engine.editor_hint:
		return
	set_time()
	get_apps()
	_print_folder_data()
	add_desktop_folders()
	open_program("Browser", ["this can be anything"])


func set_time() -> void:
	var time_dict := Time.get_time_dict_from_system()
	time.text = "%d:%02d %s" % \
			[12 if time_dict.hour % 12 == 0 else time_dict.hour % 12,
			time_dict.minute, "AM" if time_dict.hour < 12 or time_dict.hour == 24 else "PM"]


func add_desktop_folders() -> void:
	for child in folder_data.children:
		var item
		if child is Folder:
			item = FolderButton.instance()
		elif child is Txt:
			item = TxtButton.instance()
		if item:
			item.item_name = child.name
			item.connect("pressed", self, "open_program", [child.app_name, [child]])
			desktop.add_child(item)


func get_apps() -> void:
	for child in apps_parent.get_children():
		app_programs[child.app_name] = load(child.open_with)
		apps_to_buttons[child.app_name] = child
		child.connect("pressed", self, "_on_app_clicked", [child])


func open_program(app_name: String, args: Array = []) -> void:
	var app_button: TaskbarApp = apps_to_buttons[app_name]
	var program = app_programs[app_name].instance()
	match app_name:
		"Files":
			program.file_system = folder_data
			program.path = args
			program.connect("open_program", self, "open_program")
		"Text":
			program.file = args[0]
		"Browser":
			if args:
				program.stopped = false
	program.connect("minimized", self, "_on_program_minimized", [app_button, program])
	program.connect("closed", self, "_on_program_closed", [app_button, program])
	get_parent().call_deferred("add_child", program)
	if not app_name in running_programs:
		running_programs[app_name] = {}
	running_programs[app_name][program] = 1


func _print_folder_data() -> void:
	_print_folder_data_helper(folder_data)


func _print_folder_data_helper(curr, level: int = 0) -> void:
	if curr == null:
		return
	var tabs = ""
	for i in level:
		tabs += "\t"
	print(tabs + curr.name)
	if not "children" in curr or !curr.children:
		return
	for child in curr.children:
		_print_folder_data_helper(child, level + 1)


func _on_Timer_timeout() -> void:
	set_time()


func _on_app_clicked(app_button: TaskbarApp) -> void:
	if app_button.app_name in running_programs:
		var close_programs := true
		for program in running_programs[app_button.app_name]:
			if program.minimized:
				close_programs = false
				break
		for program in running_programs[app_button.app_name]:
			if close_programs:
				program.set_minimized(true,
						app_button.rect_global_position + \
						app_button.rect_size / 2)
			else:
				program.set_minimized(false)
	else:
		open_program(app_button.app_name)


func _on_program_minimized(app_button: TaskbarApp, program: Window):
	program.set_minimized(true,
			app_button.rect_global_position + app_button.rect_size / 2)


func _on_program_closed(app_button: TaskbarApp, program: Window):
	running_programs[app_button.app_name].erase(program)
	if running_programs[app_button.app_name].empty():
		running_programs.erase(app_button.app_name)
