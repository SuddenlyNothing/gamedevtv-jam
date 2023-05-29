extends Node

# Used for input remapping and control displays
var user_keys := PoolStringArray([
	"pause",
	"continue",
	"attack",
	"left",
	"right"
])

# Used for formatting strings to display the correct key.
var input_format := {}

var seen_player := false

var scam_seen := false

var visited_folders := {}
