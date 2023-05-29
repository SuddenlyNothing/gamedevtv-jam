tool
class_name FileSystem
extends Resource

export(String) var name = "Desktop"
var children


func _set(property: String, value) -> bool:
	if property == "children":
		children = value
		return true
	return false


func _get(property:String):
	if property == "children":
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
					str(PROPERTY_HINT_RESOURCE_TYPE) + ":Folder,Txt"
		}
	]
