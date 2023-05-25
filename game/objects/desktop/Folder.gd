tool
extends Area2D

signal entered_folder(folder_name)
signal exited_folder(entered_folder)

var folder_data


func _ready() -> void:
	if Engine.editor_hint:
		return
	_print_folder_data()


func _print_folder_data() -> void:
	_print_folder_data_helper(folder_data)


func _print_folder_data_helper(curr: FolderData, level: int = 0) -> void:
	if curr == null:
		return
	var tabs = ""
	for i in level:
		tabs += "\t"
	print(tabs + curr.name)
	if !curr.children:
		return
	for child in curr.children:
		_print_folder_data_helper(child, level + 1)


func _set(property: String, value) -> bool:
	if property == "property_name":
		folder_data = value
		return true
	return false


func _get(property:String):
	if property == "property_name":
		return folder_data
	return null


func _get_property_list() -> Array:
	return [
		{
			name = "folder_data",
			type = TYPE_OBJECT,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_RESOURCE_TYPE,
			hint_string = "FolderData"
		}
	]
