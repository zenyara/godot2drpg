extends CanvasLayer
class_name FogLayer
## Atmospheric fog overlay system

@export var fog_texture: Texture2D
@export var fog_color: Color = Color(1.0, 1.0, 1.0, 0.3)  # White, 30% opacity
@export var fog_speed: float = 0.1  # Slow drift speed
@export var fog_intensity: float = 0.3  # 0.0 = invisible, 1.0 = opaque

var fog_sprites: Array = []
var time_passed: float = 0.0

func _ready() -> void:
	layer = 10  # Above background, below UI
	
	if fog_texture:
		create_fog_layer()
	else:
		# Create simple fog overlay if no texture
		create_simple_fog()

func create_fog_layer() -> void:
	"""Create fog using texture (for moving fog banks)"""
	# Create multiple fog sprites for seamless scrolling
	for i in range(3):
		var sprite = Sprite2D.new()
		sprite.texture = fog_texture
		sprite.modulate = fog_color
		sprite.centered = false
		sprite.position.x = i * fog_texture.get_width()
		add_child(sprite)
		fog_sprites.append(sprite)

func create_simple_fog() -> void:
	"""Create simple fog overlay using ColorRect"""
	var fog_rect = ColorRect.new()
	fog_rect.size = get_viewport().get_visible_rect().size
	fog_rect.color = Color(fog_color.r, fog_color.g, fog_color.b, fog_intensity)
	fog_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fog_rect)

func _process(delta: float) -> void:
	if fog_sprites.is_empty():
		return
	
	time_passed += delta
	
	# Move fog sprites slowly
	for sprite in fog_sprites:
		sprite.position.x -= fog_speed * delta * 10.0
		
		# Reset position for seamless loop
		if sprite.position.x < -fog_texture.get_width():
			sprite.position.x += fog_texture.get_width() * 3

func set_fog_intensity(intensity: float) -> void:
	"""Change fog opacity (0.0 to 1.0)"""
	fog_intensity = clamp(intensity, 0.0, 1.0)
	fog_color.a = fog_intensity
	
	for sprite in fog_sprites:
		sprite.modulate = fog_color

func set_fog_color(color: Color) -> void:
	"""Change fog color"""
	fog_color = Color(color.r, color.g, color.b, fog_intensity)
	
	for sprite in fog_sprites:
		sprite.modulate = fog_color

func set_fog_speed(speed: float) -> void:
	"""Change fog movement speed"""
	fog_speed = speed
