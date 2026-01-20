extends Resource
class_name ScreenData
## Data structure for screen/area definitions (200+ screens)

@export var screen_id: int = 0
@export var screen_name: String = ""
@export var area_type: String = ""  # forest, cave, dungeon, town, etc.

# Visual
@export_group("Background")
@export var background_texture: Texture2D
@export var background_scale: Vector2 = Vector2.ONE
@export var parallax_layers: Array = []

# Connected screens (for navigation)
@export_group("Navigation")
@export var connected_left: int = -1  # Screen ID to the left
@export var connected_right: int = -1  # Screen ID to the right
@export var connected_up: int = -1  # Screen ID above (ladders, etc.)
@export var connected_down: int = -1  # Screen ID below

# Portals in this screen
@export var portal_locations: Array = []  # [{position, destination_screen_id}, ...]

# Spawn data
@export_group("Spawns")
@export var enemy_spawns: Array = []  # [{enemy_id, position, respawn_time}, ...]
@export var npc_spawns: Array = []  # [{npc_id, position}, ...]
@export var item_pickups: Array = []  # [{item_id, position, respawn_time}, ...]

# Environment
@export_group("Environment")
@export var ambient_music: AudioStream
@export var ambient_sound: AudioStream
@export var weather_type: String = "clear"  # clear, rain, snow, fog
@export var time_of_day: String = "day"  # day, dusk, night, dawn
@export var is_underwater: bool = false
@export var requires_swimming: bool = false

# Boundaries
@export var bounds_left: float = 0.0
@export var bounds_right: float = 1920.0
@export var ground_level: float = 0.0

# Quest triggers
@export var quest_triggers: Array = []  # [{quest_id, trigger_type, position}, ...]

# Special properties
@export var safe_zone: bool = false  # No combat allowed
@export var pvp_enabled: bool = false
@export var first_visit_dialogue: String = ""
