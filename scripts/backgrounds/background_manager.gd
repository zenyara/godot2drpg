extends ParallaxBackground
class_name BackgroundManager
## Manages multiple background layers with parallax scrolling

# Sky layer (furthest back, slowest)
var sky_layer: ParallaxLayer = null

# Additional layers
var treeline_layer: ParallaxLayer = null
var cloud_layer: ParallaxLayer = null
var mountain_layer: ParallaxLayer = null
var path_layer: ParallaxLayer = null
var foreground_layer: ParallaxLayer = null

func _ready() -> void:
	# Follow the camera
	scroll_ignore_camera_zoom = false
	
	# Create default sky layer
	create_sky_layer()
	
	# Create cloud layer (behind treeline)
	create_cloud_layer()
	
	# Create treeline layer
	create_treeline_layer()
	
	# Create ground path layer (main game layer)
	create_path_layer()

func create_sky_layer() -> void:
	"""Create the sky background layer"""
	# Load the sky texture
	var sky_texture = load("res://assets/backgrounds/bg-sky.jpg")
	
	if not sky_texture:
		push_warning("Sky texture not found!")
		return
	
	# Create parallax layer
	sky_layer = ParallaxLayer.new()
	sky_layer.name = "SkyLayer"
	sky_layer.motion_scale = Vector2(0.0, 0.0)  # Sky doesn't move (furthest back)
	sky_layer.motion_mirroring = Vector2.ZERO
	add_child(sky_layer)
	
	# Create sprite
	var sprite = Sprite2D.new()
	sprite.texture = sky_texture
	sprite.centered = false
	sprite.position = Vector2.ZERO
	
	# Scale to cover screen (gradient from top down)
	var viewport_size = get_viewport().get_visible_rect().size
	var texture_size = sky_texture.get_size()
	
	# Scale to fit viewport width and height
	var scale_x = viewport_size.x / texture_size.x
	var scale_y = viewport_size.y / texture_size.y
	var scale = max(scale_x, scale_y)  # Cover the entire screen
	
	sprite.scale = Vector2(scale, scale)
	
	# Set z-index to be behind everything
	sprite.z_index = -1000
	
	sky_layer.add_child(sprite)
	
	print("Sky background layer created")

func create_treeline_layer() -> void:
	"""Create the treeline background layer (sits on top of sky)"""
	# Load the treeline texture
	var treeline_texture = load("res://assets/backgrounds/bg-treeline.png")
	
	if not treeline_texture:
		push_warning("Treeline texture not found!")
		return
	
	# Create parallax layer
	treeline_layer = ParallaxLayer.new()
	treeline_layer.name = "TreelineLayer"
	treeline_layer.motion_scale = Vector2(0.3, 0.0)  # Slow parallax for distant trees
	treeline_layer.motion_mirroring = Vector2(treeline_texture.get_width(), 0)  # Tile horizontally
	add_child(treeline_layer)
	
	# Create sprite
	var sprite = Sprite2D.new()
	sprite.texture = treeline_texture
	sprite.centered = false
	
	# Position at bottom of screen (treeline at horizon)
	var viewport_size = get_viewport().get_visible_rect().size
	sprite.position.y = viewport_size.y - treeline_texture.get_height()
	
	# Set z-index above sky but below main game
	sprite.z_index = -950
	
	treeline_layer.add_child(sprite)
	
	print("Treeline background layer created")

func create_cloud_layer() -> void:
	"""Create the cloud background layer (behind treeline, in front of sky)"""
	# Load the cloud texture
	var cloud_texture = load("res://assets/backgrounds/bg-clouds.png")
	
	if not cloud_texture:
		push_warning("Cloud texture not found!")
		return
	
	# Create parallax layer
	cloud_layer = ParallaxLayer.new()
	cloud_layer.name = "CloudLayer"
	cloud_layer.motion_scale = Vector2(0.2, 0.0)  # Slower than treeline (farther away)
	cloud_layer.motion_mirroring = Vector2(cloud_texture.get_width(), 0)  # Tile horizontally
	add_child(cloud_layer)
	
	# Create sprite
	var sprite = Sprite2D.new()
	sprite.texture = cloud_texture
	sprite.centered = false
	sprite.position = Vector2.ZERO  # Clouds at top/middle of screen
	
	# Set z-index behind treeline but in front of sky
	sprite.z_index = -975
	
	cloud_layer.add_child(sprite)
	
	print("Cloud background layer created")

func create_path_layer() -> void:
	"""Create the ground path layer (main game layer where player walks)"""
	# Load the path texture
	var path_texture = load("res://assets/backgrounds/bg-path.png")
	
	if not path_texture:
		push_warning("Path texture not found!")
		return
	
	# Create parallax layer
	path_layer = ParallaxLayer.new()
	path_layer.name = "PathLayer"
	path_layer.motion_scale = Vector2(1.0, 0.0)  # Same speed as player (main game layer)
	path_layer.motion_mirroring = Vector2(path_texture.get_width(), 0)  # Tile horizontally
	add_child(path_layer)
	
	# Create sprite
	var sprite = Sprite2D.new()
	sprite.texture = path_texture
	sprite.centered = false
	
	# Position at bottom of screen (ground level)
	var viewport_size = get_viewport().get_visible_rect().size
	sprite.position.y = viewport_size.y - path_texture.get_height()
	
	# Set z-index for main game layer (player walks on this)
	sprite.z_index = -50
	
	path_layer.add_child(sprite)
	
	print("Path ground layer created")

func add_cloud_layer(texture: Texture2D, speed: float = 0.2) -> void:
	"""Add a cloud layer that scrolls slowly"""
	if cloud_layer:
		cloud_layer.queue_free()
	
	cloud_layer = ParallaxLayer.new()
	cloud_layer.name = "CloudLayer"
	cloud_layer.motion_scale = Vector2(speed, 0.0)
	cloud_layer.motion_mirroring = Vector2(texture.get_width(), 0)
	add_child(cloud_layer)
	
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.z_index = -900
	cloud_layer.add_child(sprite)

func add_mountain_layer(texture: Texture2D, speed: float = 0.5) -> void:
	"""Add a mountain/distant objects layer"""
	if mountain_layer:
		mountain_layer.queue_free()
	
	mountain_layer = ParallaxLayer.new()
	mountain_layer.name = "MountainLayer"
	mountain_layer.motion_scale = Vector2(speed, 0.0)
	mountain_layer.motion_mirroring = Vector2(texture.get_width(), 0)
	add_child(mountain_layer)
	
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position.y = get_viewport().get_visible_rect().size.y - texture.get_height()
	sprite.z_index = -800
	mountain_layer.add_child(sprite)

func add_foreground_layer(texture: Texture2D, speed: float = 1.2) -> void:
	"""Add a foreground layer (parallax effect in front)"""
	if foreground_layer:
		foreground_layer.queue_free()
	
	foreground_layer = ParallaxLayer.new()
	foreground_layer.name = "ForegroundLayer"
	foreground_layer.motion_scale = Vector2(speed, 0.0)
	foreground_layer.motion_mirroring = Vector2(texture.get_width(), 0)
	add_child(foreground_layer)
	
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.z_index = -100
	foreground_layer.add_child(sprite)

func clear_layers() -> void:
	"""Remove all dynamic layers (keeps sky, clouds, treeline, and path)"""
	if mountain_layer:
		mountain_layer.queue_free()
		mountain_layer = null
	if foreground_layer:
		foreground_layer.queue_free()
		foreground_layer = null

func remove_treeline() -> void:
	"""Remove the treeline layer"""
	if treeline_layer:
		treeline_layer.queue_free()
		treeline_layer = null

func remove_path() -> void:
	"""Remove the path layer"""
	if path_layer:
		path_layer.queue_free()
		path_layer = null

func set_sky_texture(texture: Texture2D) -> void:
	"""Change the sky texture"""
	if sky_layer:
		sky_layer.queue_free()
	
	create_sky_layer()
