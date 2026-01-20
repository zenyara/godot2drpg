extends ParallaxLayer
class_name BackgroundLayer
## Individual background layer with parallax scrolling

@export var texture: Texture2D
@export var layer_speed: Vector2 = Vector2(0.5, 0.0)  # Parallax speed
@export var tile_horizontal: bool = true
@export var tile_vertical: bool = false
@export var layer_scale: Vector2 = Vector2(1.0, 1.0)

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Set parallax motion
	motion_scale = layer_speed
	
	if sprite and texture:
		sprite.texture = texture
		sprite.scale = layer_scale
		sprite.centered = false
		
		# Enable tiling
		if tile_horizontal or tile_vertical:
			sprite.region_enabled = true
			sprite.region_rect = Rect2(0, 0, get_viewport().get_visible_rect().size.x * 2, texture.get_height())
