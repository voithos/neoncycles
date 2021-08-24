extends Node

# Music management.

const FADE_TIME = 10
const MIN_DB = -80.0
const MUSIC_DB = -24.0

class MusicBox extends Node:
    var player
    # We have two players to allow simultaneous playback into effects-based
    # audio buses.
    var alt_player
    var tween
    var last_playback_pos = 0
    
    func _init(stream):
        player = AudioStreamPlayer.new()
        alt_player = AudioStreamPlayer.new()
        add_child(player)
        add_child(alt_player)
        player.bus = "Music"
        alt_player.bus = "MusicAlt"
        player.stream = stream
        alt_player.stream = stream
        player.volume_db = MIN_DB
        alt_player.volume_db = MIN_DB
        
        tween = Tween.new()
        add_child(tween)
        self.tween.connect("tween_completed", self, "on_fade_complete")

    func set_volume_db(volume_db):
        player.volume_db = volume_db
        alt_player.volume_db = volume_db

    func fade_in():
        player.play(last_playback_pos)
        alt_player.play(last_playback_pos)
        last_playback_pos = 0
        tween.remove_all()
        tween.interpolate_method(self, "set_volume_db", player.volume_db, MUSIC_DB, \
                FADE_TIME, Tween.TRANS_EXPO, Tween.EASE_OUT)
        tween.start()

    func fade_out():
        tween.remove_all()
        tween.interpolate_method(self, "set_volume_db", player.volume_db, MIN_DB, \
                FADE_TIME, Tween.TRANS_EXPO, Tween.EASE_IN)
        tween.start()

    func is_active():
        return tween.is_active()

    func play():
        player.volume_db = MUSIC_DB
        alt_player.volume_db = MUSIC_DB
        player.play()
        alt_player.play()
    
    func stop():
        player.stop()
        alt_player.stop()

    func on_fade_complete(_object, _key):
        if player.volume_db == MIN_DB:
            tween.remove_all()
            last_playback_pos = player.get_playback_position()
            player.stop()
            alt_player.stop()

# Add music here
var battle = preload("res://assets/battle.ogg")
var menu = preload("res://assets/menu.ogg")

var menu_musicbox
var battle_musicbox

# The last MusicBox that was active.
var last_musicbox = null

const MUSIC_MENU = "MENU"
const MUSIC_BATTLE = "BATTLE"
var current_music = null

func _ready():
    _load_music()

func _load_music():
    battle_musicbox = MusicBox.new(battle)
    add_child(battle_musicbox)
    menu_musicbox = MusicBox.new(menu)
    add_child(menu_musicbox)

func play_menu():
    if current_music != MUSIC_MENU:
        if last_musicbox:
            last_musicbox.stop()
        menu_musicbox.play()
        current_music = MUSIC_MENU
        last_musicbox = menu_musicbox

func play_battle():
      if current_music != MUSIC_BATTLE:
        if last_musicbox:
            last_musicbox.stop()
        battle_musicbox.play()
        current_music = MUSIC_BATTLE
        last_musicbox = battle_musicbox
