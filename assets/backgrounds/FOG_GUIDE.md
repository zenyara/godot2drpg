# Fog Effects Guide

## Quick Start - No Texture Needed!

The easiest way to add fog is without a texture:

```gdscript
# In game_world.gd, uncomment the fog line:
_add_fog_effect()

# Or manually add to any scene:
background.add_fog_layer(null, 0.3, 0.15, -500)
```

This creates a simple semi-transparent overlay - perfect for light atmospheric fog!

---

## Fog Parameters Explained

```gdscript
background.add_fog_layer(texture, intensity, speed, z_index)
```

### 1. Texture (Optional)
- **null** = Simple color overlay (quick & easy)
- **Texture2D** = Moving fog banks (more realistic)

### 2. Intensity (0.0 - 1.0)
Controls fog opacity:
- **0.2** = Very light haze (barely visible)
- **0.3** = Light fog ✓ **RECOMMENDED DEFAULT**
- **0.5** = Medium fog (atmospheric)
- **0.7** = Thick fog (limited visibility)
- **0.9** = Dense fog (spooky/horror games)

### 3. Speed (0.0 - 1.0+)
Controls fog drift speed:
- **0.05** = Almost static
- **0.15** = Slow drift ✓ **RECOMMENDED DEFAULT**
- **0.3** = Medium speed (windy)
- **0.5** = Fast (storm effects)

### 4. Z-Index
Controls fog depth placement:
- **-100 to -200** = Ground fog (near player)
- **-300 to -500** = Mid-distance ✓ **RECOMMENDED**
- **-600 to -900** = Background haze (behind treeline)

---

## Fog Placement Examples

### Ground Fog (Eerie/Spooky)
```gdscript
background.add_fog_layer(null, 0.4, 0.1, -100)
```
- Thick fog near the ground
- Slow movement
- Close to player

### Atmospheric Fog (Default/Realistic)
```gdscript
background.add_fog_layer(null, 0.3, 0.15, -500)
```
- Light fog in the distance
- Natural drift
- Between treeline and path

### Background Haze (Distant/Subtle)
```gdscript
background.add_fog_layer(null, 0.2, 0.05, -900)
```
- Very light haze
- Barely moving
- Behind everything

---

## Creating Fog Textures (Advanced)

If you want moving fog banks instead of simple overlays:

### Option 1: Meshy.ai
1. Generate a fog/mist 3D model
2. Render from top-down view
3. Export as PNG with transparency
4. Name: `bg-fog.png`

### Option 2: Image Editor (Photoshop/GIMP)
1. Create new image: 1920x600 (horizontal fog bank)
2. Background: Transparent
3. Add clouds/fog brush strokes in white
4. Apply Gaussian blur (30-50px)
5. Reduce opacity to 50-70%
6. Save as PNG with transparency

### Option 3: Free Resources
Download free fog overlays from:
- OpenGameArt.org
- Itch.io (free assets)
- Kenney.nl (fog sprites)

**Recommended Sizes:**
- Width: 1920-3840px (wider = less tiling visible)
- Height: 400-800px (covers middle of screen)

---

## Using Textured Fog

```gdscript
# Load your fog texture
var fog_texture = load("res://assets/backgrounds/bg-fog.png")

# Add moving fog banks
background.add_fog_layer(fog_texture, 0.5, 0.2, -300)
```

---

## Dynamic Fog Control

### Change Fog Intensity (Day/Night)
```gdscript
# Morning: Light fog
background.set_fog_intensity(0.2)

# Evening: Thicker fog
background.set_fog_intensity(0.6)

# Night: Dense fog
background.set_fog_intensity(0.8)
```

### Remove Fog
```gdscript
background.remove_fog()
```

### Conditional Fog (Weather System)
```gdscript
func set_weather(weather_type: String):
	match weather_type:
		"clear":
			background.remove_fog()
		"foggy":
			background.add_fog_layer(null, 0.5, 0.2, -400)
		"misty":
			background.add_fog_layer(null, 0.3, 0.1, -600)
		"stormy":
			background.add_fog_layer(null, 0.7, 0.5, -200)
```

---

## Fog by Biome/Area Type

### Forest
```gdscript
background.add_fog_layer(null, 0.35, 0.12, -450)
# Medium fog, very slow, mid-distance
```

### Cave/Dungeon
```gdscript
background.add_fog_layer(null, 0.6, 0.05, -200)
# Thick fog, barely moving, close to player
```

### Mountain
```gdscript
background.add_fog_layer(null, 0.25, 0.08, -700)
# Light fog, slow, far back (altitude effect)
```

### Swamp
```gdscript
background.add_fog_layer(null, 0.7, 0.15, -150)
# Very thick fog, slow drift, ground level
```

### Desert
```gdscript
background.add_fog_layer(null, 0.15, 0.3, -800)
# Heat haze, light, faster movement, distant
```

---

## Performance Tips

1. **Simple fog is faster** than textured fog
2. **One fog layer** is usually enough
3. **Lower z-index** values are cheaper (rendered less often)
4. **Smaller textures** = better performance

---

## Color Tinted Fog

You can modify fog color in the code:

```gdscript
# In background_manager.gd, line ~167, change:
fog_rect.color = Color(0.8, 0.85, 0.9, intensity)

# Examples:
# Blue-tinted (default):     Color(0.8, 0.85, 0.9, intensity)
# White/neutral:             Color(1.0, 1.0, 1.0, intensity)
# Green (toxic/swamp):       Color(0.7, 0.9, 0.7, intensity)
# Purple (magical):          Color(0.9, 0.7, 0.9, intensity)
# Yellow (dusty/desert):     Color(0.95, 0.9, 0.7, intensity)
# Red (danger/lava):         Color(0.95, 0.7, 0.7, intensity)
```

---

## Troubleshooting

**Fog not visible?**
- Check intensity (try 0.5 for testing)
- Check z-index (try -300)
- Make sure background exists

**Fog too thick?**
- Lower intensity (0.2-0.3)
- Move z-index further back (-700 to -900)

**Fog moving too fast/slow?**
- Adjust speed parameter (0.1-0.3 is good range)

**Fog blocks UI?**
- Fog layer is 10, UI should be 100+
- Check CanvasLayer values

---

## Example: Complete Foggy Scene

```gdscript
extends Node2D

@onready var background = $Background

func _ready():
	# Set up foggy environment
	
	# Background layers (already active)
	# - Sky
	# - Clouds
	# - Treeline
	# - Path
	
	# Add atmospheric fog
	background.add_fog_layer(null, 0.4, 0.15, -500)
	
	# Optional: Animate fog intensity
	var tween = create_tween().set_loops()
	tween.tween_method(
		background.set_fog_intensity,
		0.3,  # Min intensity
		0.5,  # Max intensity
		5.0   # Duration
	)
	tween.tween_method(
		background.set_fog_intensity,
		0.5,
		0.3,
		5.0
	)
```

This creates a fog that gently pulses between light and medium density!

---

## Pro Tips

1. **Subtle is better** - Start with 0.3 intensity
2. **Layer fog** - Multiple thin layers look better than one thick layer
3. **Match biome** - Forest = medium fog, desert = light haze, swamp = thick fog
4. **Animate it** - Slowly change intensity for atmosphere
5. **Color matters** - Tint fog to match time of day

---

**Your fog is now ready to add atmosphere to your game!** 🌫️✨
