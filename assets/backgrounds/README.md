# Background Assets Guide

## Current Backgrounds

### Sky Layer
- **File**: `bg-sky.jpg`
- **Usage**: Main sky gradient background (furthest layer, doesn't scroll)
- **Size**: Scales automatically to fill screen
- **Position**: Covers entire viewport from top to bottom
- **Z-Index**: -1000

### Cloud Layer
- **File**: `bg-clouds.png`
- **Usage**: Distant clouds (behind treeline)
- **Motion Scale**: 0.2 (slower than treeline, farther away)
- **Position**: Top/middle of screen
- **Tiling**: Horizontal (repeats seamlessly)
- **Z-Index**: -975

### Treeline Layer
- **File**: `bg-treeline.png`
- **Usage**: Distant treeline at horizon (slow parallax)
- **Motion Scale**: 0.3 (slow movement for depth)
- **Position**: Bottom of screen (anchored to horizon)
- **Tiling**: Horizontal (repeats seamlessly)
- **Z-Index**: -950

### Path/Ground Layer
- **File**: `bg-path.png`
- **Usage**: Main ground/path where player walks (generic fallback)
- **Motion Scale**: 1.0 (same speed as player - main game layer)
- **Position**: Full screen (0, 0) - 1920x1080
- **Tiling**: Horizontal (repeats seamlessly)
- **Z-Index**: -1 (just below player, top background layer)

## Adding New Background Layers

### Layer Types

1. **Sky Layer** (motion_scale = 0.0)
   - Furthest back
   - Doesn't move with camera
   - Examples: Sky gradient, stars, distant atmosphere

2. **Cloud Layer** (motion_scale = 0.2)
   - Slow-moving clouds
   - Tiles horizontally
   - Examples: Clouds, flying birds, distant weather

3. **Mountain/Distant Layer** (motion_scale = 0.5)
   - Medium distance
   - Mountains, distant buildings, horizon
   - Anchored to bottom of screen

4. **Foreground Layer** (motion_scale = 1.2)
   - Closest to camera
   - Moves faster than player
   - Examples: Foreground trees, pillars, atmospheric effects

### File Naming Convention

Use descriptive names:
- `bg-sky-[variation].jpg` - Sky backgrounds
- `bg-clouds-[type].png` - Cloud layers (use PNG for transparency)
- `bg-mountains-[biome].png` - Mountain/distant layers
- `bg-foreground-[element].png` - Foreground elements

Examples:
- `bg-sky-day.jpg`
- `bg-sky-night.jpg`
- `bg-clouds-fluffy.png`
- `bg-mountains-snowy.png`
- `bg-foreground-trees.png`

### Recommended Sizes

- **Sky**: 1920x1080 or larger (will be scaled)
- **Cloud Layer**: 1920x300 to 1920x600 (PNG with transparency)
- **Mountain Layer**: 1920x400 to 1920x800 (PNG with transparency)
- **Foreground**: 1920x400 to 1920x1080 (PNG with transparency)

### File Formats

- **JPG**: For solid backgrounds (sky gradients)
- **PNG**: For layers with transparency (clouds, mountains, foreground)

## Using in Game

### In Code (BackgroundManager)

```gdscript
# Get background manager
var bg = get_node("Background")

# Change sky
var new_sky = load("res://assets/backgrounds/bg-sky-night.jpg")
bg.set_sky_texture(new_sky)

# Add cloud layer
var clouds = load("res://assets/backgrounds/bg-clouds-fluffy.png")
bg.add_cloud_layer(clouds, 0.2)  # 0.2 = slow scroll speed

# Add mountains
var mountains = load("res://assets/backgrounds/bg-mountains-snowy.png")
bg.add_mountain_layer(mountains, 0.5)  # 0.5 = medium scroll speed
```

### Per-Screen Backgrounds

Each `ScreenData` resource can specify:
- Background texture (main layer)
- Parallax layers array (additional layers)
- These are automatically loaded when you enter a screen

## Parallax Motion Scale

The `motion_scale` determines how fast a layer moves relative to the camera:

- **0.0** = Static (doesn't move) - Sky
- **0.2** = Very slow - Distant clouds
- **0.5** = Medium - Mountains
- **1.0** = Same as camera - Main ground layer
- **1.2+** = Faster than camera - Foreground effects

## Tips

1. **Keep file sizes reasonable**
   - Compress JPGs to 80-90% quality
   - Optimize PNGs with tools like TinyPNG

2. **Match art style**
   - Keep consistent color palette
   - Match lighting direction across layers
   - Maintain similar detail levels

3. **Test parallax**
   - Run the game and move around
   - Adjust motion_scale values for best effect
   - Layers should feel cohesive

4. **Organize by biome**
   - Create folders for different areas:
     - `forest/`
     - `cave/`
     - `desert/`
     - `town/`

## Example Layer Stack

A typical outdoor scene might have:

```
┌─────────────────────────────┐
│ Sky (bg-sky.jpg)            │ motion_scale: 0.0  z:-1000 ✓ ACTIVE
│ ----------------------------- │
│ Clouds (bg-clouds.png)      │ motion_scale: 0.2  z:-975  ✓ ACTIVE
│ ----------------------------- │
│ Treeline (bg-treeline.png)  │ motion_scale: 0.3  z:-950  ✓ ACTIVE
│ ----------------------------- │
│ Mountains (bg-mountains.png)│ motion_scale: 0.5  z:-800
│ ----------------------------- │
│ Path/Ground (bg-path.png)   │ motion_scale: 1.0  z:-1    ✓ ACTIVE
│ ----------------------------- │
│ PLAYER & ENEMIES            │ motion_scale: 1.0  z:0     ← You are here
│ ----------------------------- │
│ Foreground (bg-trees.png)   │ motion_scale: 1.2  z:100
└─────────────────────────────┘
```

## Current Integration

The game currently has **4 active background layers**:

1. **Sky Layer** (`bg-sky.jpg`) - Fixed position, covers full screen (motion: 0.0)
2. **Cloud Layer** (`bg-clouds.png`) - Slow parallax (motion: 0.2), drifting in sky
3. **Treeline Layer** (`bg-treeline.png`) - Medium parallax (motion: 0.3), horizon line
4. **Path/Ground Layer** (`bg-path.png`) - Main game layer (motion: 1.0), where player walks

All layers load automatically on game start and create a complete parallax environment from sky to ground!
