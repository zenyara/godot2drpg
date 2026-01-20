# Meshy.ai Asset Creation Workflow

## Overview
This document outlines the workflow for creating game assets using Meshy.ai for the EmpireRPG project.

## Account Setup
1. Sign up at https://www.meshy.ai/
2. Subscribe to a paid plan (recommended for commercial use)
3. Familiarize yourself with the interface

## Asset Categories Needed

### 1. Character Sprites (Player Classes - 12 Total)
Each class needs:
- Idle animation (4-8 frames)
- Walk animation (6-8 frames)
- Run animation (6-8 frames)
- Attack animations (multiple types, 4-6 frames each)
- Hit/hurt animation (2-3 frames)
- Death animation (4-6 frames)
- Special ability animations (class-specific)

### 2. Enemy Sprites (70+ Types)
Each enemy needs:
- Idle animation (4-8 frames)
- Walk animation (6-8 frames)
- Attack animation (4-6 frames)
- Hit animation (2-3 frames)
- Death animation (4-6 frames)

### 3. NPC Sprites
Each NPC needs:
- Idle animation (4-8 frames)
- Talk animation (optional, 2-4 frames)

### 4. Background Screens (200 Total)
- Wide landscape scenes (1920x1080 or higher)
- Various biomes (forest, desert, cave, dungeon, town, etc.)
- Different times of day (day, dusk, night, dawn)
- Weather variants (clear, rain, snow, fog)

## Meshy.ai Generation Process

### Creating 3D Models

#### Method 1: Text-to-3D
1. Go to "Text to 3D" in Meshy.ai
2. Write detailed prompt:
   ```
   Example: "A fierce wolf with gray fur, muscular build, 
   sharp teeth, aggressive pose, fantasy RPG style, 
   low-poly game asset, neutral background"
   ```
3. Choose style: "Game Asset" or "Low Poly"
4. Set quality: High (for main characters), Medium (for common enemies)
5. Generate (takes 5-15 minutes)
6. Review and download FBX or GLB format

#### Method 2: Image-to-3D
1. Upload reference image
2. Adjust settings
3. Generate
4. Download

### Recommended Prompts by Category

#### Player Characters
```
Bandit Class:
"Agile rogue character with dual daggers, leather armor, 
hooded cloak, sneaky pose, fantasy RPG style, game asset"

Hero Class:
"Muscular warrior with sword and shield, plate armor, 
heroic stance, fantasy RPG style, game asset"

Mage Class:
"Wizard with flowing robes, holding staff, magical aura, 
wise appearance, fantasy RPG style, game asset"
```

#### Enemies
```
Wolf (Medium):
"Gray wolf, medium size, aggressive stance, sharp fangs, 
realistic fur, forest predator, game asset"

Dragon:
"Fierce dragon, red scales, spread wings, breathing fire, 
imposing size, fantasy creature, game asset"

Zombie:
"Undead zombie, rotting flesh, tattered clothes, 
shambling pose, horror game asset"
```

#### Backgrounds
```
Forest Scene:
"Dense forest landscape, tall trees, dappled sunlight, 
mystical atmosphere, side-scrolling game background, 
wide landscape, 16:9 ratio"

Cave Interior:
"Dark cave interior, stalactites, glowing crystals, 
rocky walls, atmospheric lighting, game background"

Medieval Town:
"Fantasy medieval town, stone buildings, cobblestone streets, 
market stalls, NPCs in background, game environment"
```

## Rendering to 2D Sprites

### Option A: Blender (Free, Recommended)

1. **Import Model**:
   - File → Import → FBX/GLB
   - Scale model appropriately

2. **Set Up Camera**:
   - Add camera at 90° angle (side view for sidescroller)
   - Frame character in center
   - Switch to orthographic view

3. **Lighting**:
   - Add 3-point lighting
   - Avoid harsh shadows (unless stylistic)
   - Keep consistent across all sprites

4. **Animation**:
   - If model has bones, create animations
   - Or manually rotate/pose model for each frame

5. **Render Settings**:
   - Resolution: 512x512 (characters), 1920x1080 (backgrounds)
   - Format: PNG with transparency
   - Background: Transparent
   - Samples: 64-128 (balance quality/speed)

6. **Batch Render**:
   - Set up animation timeline
   - Render all frames
   - Export as numbered sequence

7. **Export**:
   - Save renders to organized folders
   - Name consistently: `character_action_frame001.png`

### Option B: Meshy.ai Built-in Renderer

1. In Meshy.ai, select model
2. Go to "Render" tab
3. Adjust camera angle
4. Set resolution
5. Render image
6. Download

**Note**: Meshy's renderer is simpler but less flexible than Blender.

## Post-Processing

### Image Editing (Photoshop/GIMP)

1. **Crop & Resize**:
   - Trim excess transparency
   - Resize to target game size
   - Keep consistent dimensions per character type

2. **Color Correction**:
   - Adjust brightness/contrast
   - Match art style across all sprites
   - Create variants (frost, fire, etc.) using hue shift

3. **Outline** (Optional):
   - Add pixel-perfect outline for visibility
   - Use 1-2px black or dark outline

4. **Sprite Sheet Creation**:
   - Combine animation frames into single sheet
   - Use consistent spacing
   - Label each animation

## Import to Godot

### For Characters/Enemies

1. **Import Sprite Sheet**:
   - Copy PNG to `assets/sprites/characters/` or `assets/sprites/enemies/`
   - Godot auto-imports

2. **Create SpriteFrames**:
   - Right-click in FileSystem → New Resource → SpriteFrames
   - Open in inspector
   - Add animations: idle, walk, attack, etc.
   - Import frames from sprite sheet
   - Set FPS (usually 8-12 for pixel art style)
   - Save as `character_name_frames.tres`

3. **Assign to AnimatedSprite2D**:
   - In enemy/player scene, select AnimatedSprite2D node
   - Assign SpriteFrames resource
   - Test animations

### For Backgrounds

1. **Import Image**:
   - Copy to `assets/backgrounds/`
   - Auto-imports as Texture2D

2. **Create ScreenData**:
   - Right-click in `resources/screens/`
   - New Resource → ScreenData
   - Assign background_texture
   - Save

3. **Test in Game**:
   - Load screen using console: `teleport <screen_id>`

## Asset Organization

### Folder Structure
```
assets/
├── sprites/
│   ├── characters/
│   │   ├── bandit/
│   │   │   ├── bandit_idle.png
│   │   │   ├── bandit_walk.png
│   │   │   └── bandit_attack.png
│   │   ├── hero/
│   │   └── mage/
│   ├── enemies/
│   │   ├── wolf/
│   │   ├── dragon/
│   │   └── zombie/
│   └── items/
├── backgrounds/
│   ├── forest/
│   ├── cave/
│   ├── dungeon/
│   └── town/
└── ui/
```

### Naming Conventions
- Characters: `classname_animation_frameXXX.png`
  - Example: `bandit_attack_frame001.png`
- Enemies: `enemytype_variant_animation_frameXXX.png`
  - Example: `wolf_medium_walk_frame001.png`
- Backgrounds: `area_biome_variation_XXX.png`
  - Example: `forest_clearing_day_001.png`

## Production Pipeline

### For All 200 Backgrounds
1. Create 20 biome categories (forest, cave, desert, etc.)
2. Generate 10 variations per biome
3. Create day/night/weather variants as needed
4. Batch render in Blender
5. Import to Godot
6. Create ScreenData resources
7. Connect screens in sequence

### For All 70 Enemies
1. Group by category (bears, wolves, dragons, etc.)
2. Generate base models for each type
3. Create size variants (small, medium, large)
4. Create elemental variants (frost, fire, etc.)
5. Create NPC friendly versions (recolor/modify)
6. Render all animations
7. Create SpriteFrames resources
8. Create EnemyData resources

### For 12 Player Classes
1. Generate unique character model for each class
2. Render complete animation set
3. Create multiple weapon/armor variants
4. Create SpriteFrames
5. Create PlayerClassData resources
6. Test each class in-game

## Quality Checklist

Before finalizing an asset:
- [ ] Consistent art style with other assets
- [ ] Appropriate resolution
- [ ] Transparent background (sprites)
- [ ] No artifacts or rendering errors
- [ ] Proper naming convention
- [ ] All required animations complete
- [ ] Tested in-game
- [ ] Documented in asset list

## Time Estimates

Per asset (approximate):
- **Character Model**: 30-60 minutes (generation + refinement)
- **Animation Rendering**: 1-2 hours (setup + render all frames)
- **Background Scene**: 30-90 minutes (generation + post-processing)
- **Import & Setup**: 15-30 minutes per asset

**Total Project Estimate**:
- 200 backgrounds × 60 min = 200 hours
- 70 enemies × 120 min = 140 hours
- 12 classes × 180 min = 36 hours
- **Total: ~376 hours** (may reduce with batch processing)

## Cost Estimates (Meshy.ai)

Based on current pricing (check website for latest):
- Text-to-3D: ~200 credits per model
- Image-to-3D: ~150 credits per model
- Render: ~20 credits per render

**Estimated Total**:
- 282 models (200 backgrounds + 70 enemies + 12 classes)
- Average ~175 credits per asset
- **Total: ~49,350 credits**
- Check Meshy pricing for monthly subscription vs. pay-as-you-go

## Tips & Best Practices

1. **Batch Generation**: Generate multiple similar assets together
2. **Reuse Base Models**: Create variants from base models (save credits)
3. **Consistent Lighting**: Keep same lighting setup for all characters
4. **Test Early**: Import and test assets early to catch issues
5. **Organize Well**: Good folder structure saves time later
6. **Version Control**: Keep original 3D files for future updates
7. **Style Guide**: Create and follow a visual style guide
8. **Feedback Loop**: Generate a few assets, test, refine process, then batch produce

## Troubleshooting

### Model looks wrong
- Refine prompt with more detail
- Try different style settings
- Use reference images

### Animation doesn't loop
- Ensure first and last frames match
- Adjust timing in SpriteFrames

### Background doesn't fit
- Render at higher resolution and scale down
- Adjust camera FOV in Blender

### Sprite has artifacts
- Increase render samples
- Check transparency settings
- Clean up in image editor

## Resources

- Meshy.ai: https://www.meshy.ai/
- Blender: https://www.blender.org/
- GIMP: https://www.gimp.org/
- Aseprite: https://www.aseprite.org/ (pixel art editing)
