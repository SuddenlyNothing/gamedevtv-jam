tool
extends VFlowContainer

signal opened(item)

const FolderButton := preload("res://objects/desktop/Folder.tscn")
const TxtButton := preload("res://objects/desktop/Txt.tscn")

var folder_data: FileSystem


func _ready() -> void:
	if Engine.editor_hint:
		return
	_print_folder_data()
	add_desktop_folders()


func add_desktop_folders() -> void:
	for child in folder_data.children:
		var item
		if child is Folder:
			item = FolderButton.instance()
		elif child is Txt:
			item = TxtButton.instance()
		if item:
			item.name = child.name
			item.connect("pressed", self, "emit_signal", ["opened", child])
			add_child(item)


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


func _set(property: String, value) -> bool:
	if property == "folder_data":
		folder_data = value
		return true
	return false


func _get(property: String):
	if property == "folder_data":
		return folder_data
	return null


func _get_property_list() -> Array:
	return [
		{
			name = "folder_data",
			type = TYPE_OBJECT,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_RESOURCE_TYPE,
			hint_string = "FileSystem"
		}
	]
