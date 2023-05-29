extends Window

signal open_program(app_name, args)

const FolderButton := preload("res://objects/desktop/Folder.tscn")
const TxtButton := preload("res://objects/desktop/Txt.tscn")

var file_system: FileSystem
var path := []

onready var items_parent := $"%ItemsParent"
onready var filepath := $V/ContentParent/V/Panel/M/H/Filepath


func _ready() -> void:
	create_folders()


func create_folders() -> void:
	var dir: Resource = path.back() if path else file_system
	var path_text = "C:\\Desktop"
	for p in path:
		path_text += "\\" + p.name
	filepath.text = path_text
	for child in items_parent.get_children():
		child.queue_free()
	if not dir.children:
		return
	for child in dir.children:
		var item
		if child is Folder:
			item = FolderButton.instance()
			item.connect("pressed", self, "navigate_to", [child])
		elif child is Txt:
			item = TxtButton.instance()
			item.connect("pressed", self, "emit_signal", ["open_program", child.app_name, [child]])
		if item:
			item.item_name = child.name
			items_parent.add_child(item)


func navigate_to(f: Folder) -> void:
	path.append(f)
	create_folders()


func navigate_up() -> void:
	path.pop_back()
	create_folders()


func _on_Back_pressed() -> void:
	navigate_up()
