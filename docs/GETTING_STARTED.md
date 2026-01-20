# Getting Started with EmpireRPG Development

## Prerequisites

- **Godot Engine 4.3 or later**: Download from [godotengine.org](https://godotengine.org/)
- **Meshy.ai Account**: For generating 3D models and renders (paid subscription recommended)
- **Basic GDScript Knowledge**: Familiarity with Godot's scripting language
- **Image Editor**: For sprite editing (Photoshop, GIMP, Aseprite, etc.)

## Opening the Project

1. Launch Godot Engine
2. Click "Import" and navigate to the project folder
3. Select `project.godot`
4. Click "Import & Edit"

## Project Configuration

The project is pre-configured with:
- **Resolution**: 1920x1080 (fullscreen mode 2)
- **Pixel-perfect rendering**: Nearest-neighbor texture filtering
- **Input mappings**: WASD + Arrow keys for movement, Space/LClick for attack
- **Autoloaded systems**: All manager scripts are already set up

## Controls

### Player Controls
- **Move**: WASD or Arrow Keys
- **Attack**: Space or Left Mouse Button
- **Interact**: E
- **Jump**: Space
- **Inventory**: I
- **Quest Log**: L
- **Map**: M

### Developer Console
- **Toggle Console**: ` (backtick/grave key)

### Console Commands
- `help` - List all commands
- `god` - Toggle invincibility
- `fly` - Toggle fly mode
- `addgold <amount>` - Add gold
- `addexp <amount>` - Add experience
- `setlevel <level>` - Set player level
- `give <item_id> <amount>` - Give item
- `spawn <enemy_id>` - Spawn enemy
- `teleport <screen_id>` - Teleport to screen
- `die` - Kill player
- `killall` - Kill all nearby enemies

## Creating Your First Screen

1. **Create a ScreenData Resource**:
   - Right-click in `resources/screens/`
   - Create → Resource → ScreenData
   - Set screen_id (0-199)
   - Set screen_name
   - Assign background_texture (your 3D rendered image)
   - Set connected screens (left, right, up, down)
   - Add enemy/NPC spawns
   - Save as `screen_XXX.tres`

2. **Connect Screens**:
   - Screen 0 connects right to Screen 1: `connected_right = 1`
   - Screen 1 connects left to Screen 0: `connected_left = 0`

3. **Load the Screen**:
   - Screens are automatically loaded by ScreenManager
   - Initial screen is 0 (set in game_world.gd)

## Adding a New Enemy

1. **Create EnemyData Resource**:
   - Right-click in `resources/enemies/`
   - Create → Resource → EnemyData
   - Set enemy_id (e.g., "wolf_medium")
   - Set stats (health, attack, defense, etc.)
   - Assign sprite_frames
   - Set loot table
   - Save as `enemy_wolf_medium.tres`

2. **Add to DatabaseManager**:
   - The DatabaseManager auto-loads enemies
   - Or manually register in `_load_enemies()`

3. **Spawn in Screen**:
   - In ScreenData, add to enemy_spawns array
   - Set position and respawn_time

## Adding a Quest

1. **Define Quest Data**:
   ```gdscript
   var quest_data = {
       "id": "quest_001",
       "name": "Rat Problem",
       "description": "Kill 10 rats in the village",
       "type": "kill",
       "objectives": [
           {"type": "kill", "target": "rat_small", "required": 10, "current": 0}
       ],
       "rewards": {
           "exp": 100,
           "gold": 50,
           "items": []
       }
   }
   ```

2. **Start Quest**:
   ```gdscript
   QuestManager.start_quest("quest_001", quest_data)
   ```

3. **Track Progress**:
   - The system automatically tracks kills/collection/etc.
   - Progress updates appear in quest log

## Working with Player Classes

Each player class is defined in a PlayerClassData resource:

1. **Create Class Resource**:
   - Right-click in `resources/player_classes/`
   - Create → Resource → PlayerClassData
   - Set all stats and bonuses
   - Save as `class_bandit.tres` (for example)

2. **Use in Game**:
   ```gdscript
   GameManager.start_new_game("bandit")
   ```

## Asset Pipeline (Meshy.ai → Godot)

1. **Generate 3D Model** in Meshy.ai:
   - Create model from text prompt or image
   - Download as FBX or OBJ

2. **Render to 2D Sprites**:
   - Import model into Blender/3D software
   - Set up camera angles (idle, walk, attack, etc.)
   - Render animations as sprite sheets
   - Export as PNG with transparency

3. **Import to Godot**:
   - Place sprites in `assets/sprites/`
   - Create SpriteFrames resource
   - Assign to enemy/player AnimatedSprite2D

4. **For Backgrounds**:
   - Render full scene at 1920x1080
   - Export as PNG or JPG
   - Place in `assets/backgrounds/`
   - Assign to ScreenData background_texture

## Testing Your Changes

1. **Run the Game**: Press F5
2. **Open Console**: Press `
3. **Test Commands**: Use console to test quickly
4. **Check Logs**: View console output in Godot editor

## Common Tasks

### Add Gold
```gdscript
GameManager.add_gold(100)
```

### Give Item
```gdscript
InventoryManager.add_item("sword_iron", 1)
```

### Level Up Player
```gdscript
GameManager.add_experience(1000)
```

### Teleport to Screen
```gdscript
ScreenManager.load_screen(5)
```

## Best Practices

1. **Use Resources**: Store all game data in .tres resource files
2. **Naming Conventions**: Use snake_case for IDs (e.g., `wolf_medium`, `sword_iron`)
3. **Document Code**: Add comments for complex logic
4. **Test Incrementally**: Test each new feature immediately
5. **Version Control**: Commit regularly (if using git)
6. **Backup**: Keep backups of your Meshy.ai renders

## Troubleshooting

### Player Not Moving
- Check input actions in Project Settings
- Verify player script is attached to CharacterBody2D

### Console Not Opening
- Check keyboard layout (backtick key)
- Verify ConsoleManager is in autoload

### Screen Not Loading
- Check screen_id exists in DatabaseManager
- Verify background texture is assigned
- Check console output for errors

### Enemies Not Spawning
- Verify enemy_id matches DatabaseManager
- Check spawn position is valid
- Ensure enemy scene is set up correctly

## Next Steps

1. Review `docs/PROJECT_STRUCTURE.md` for full architecture
2. Review `docs/SYSTEMS_OVERVIEW.md` for system details
3. Start creating your 200 screens!
4. Generate assets from Meshy.ai
5. Build out quest chains
6. Create unique abilities for each class

## Support & Resources

- **Godot Documentation**: https://docs.godotengine.org/
- **Meshy.ai Docs**: https://docs.meshy.ai/
- **Project Readme**: See `readme.txt` for game design document
