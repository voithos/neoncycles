extends Spatial

export (bool) var is_two_player_mode = false
export (bool) var is_player_two = false

func _ready():
    # Ultra-hack :\ Bleh.
    # This is what I get for self-imposing a 24-hour 
    if is_two_player_mode:
        $Body.enable_two_player(is_player_two)
