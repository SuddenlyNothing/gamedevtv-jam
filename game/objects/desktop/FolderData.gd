tool
class_name FolderData
extends Resource

export(String) var name = "Folder"
var children


func _set(property: String, value) -> bool:
	if property == "property_name":
		children = value
		return true

	return false


func _get(property:String):
	if property == "property_name":
		return children

	return null


func _get_property_list() -> Array:
	return [
		{
			name = "children",
			type = TYPE_ARRAY,
			usage = PROPERTY_USAGE_DEFAULT,
			hint = PROPERTY_HINT_TYPE_STRING,
			hint_string = str(TYPE_OBJECT) + "/" + \
					str(PROPERTY_HINT_RESOURCE_TYPE) + ":FolderData"
		}
	]
