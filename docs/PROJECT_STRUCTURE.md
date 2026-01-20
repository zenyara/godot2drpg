# EmpireRPG Project Structure

## Overview
This is a 2D sidescroller RPG inspired by Murloc RPG, built in Godot 4.3. The game features 200+ unique screens, 12 player classes, 70+ enemy types, and extensive RPG systems.

## Folder Structure

```
empirerpg/
├── docs/                          # Documentation
│   ├── PROJECT_STRUCTURE.md       # This file
│   ├── GETTING_STARTED.md         # Setup and getting started guide
│   └── SYSTEMS_OVERVIEW.md        # Game systems documentation
│
├── scenes/                        # Godot scene files (.tscn)
│   ├── main.tscn                  # Main game scene
│   ├── player/                    # Player scenes
│   │   └── player.tscn            # Player character
│   ├── enemies/                   # Enemy/NPC scenes
│   │   └── enemy.tscn             # Base enemy template
│   ├── ui/                        # UI scenes
│   │   ├── hud.tscn               # Main HUD
│   │   ├── console.tscn           # Developer console
│   │   ├── inventory.tscn         # Inventory UI
│   │   └── quest_log.tscn         # Quest log UI
│   └── screens/                   # Game area/screen scenes (200+)
│       └── screen_template.tscn   # Template for new screens
│
├── scripts/                       # GDScript files
│   ├── autoload/                  # Autoloaded singleton scripts
│   │   ├── game_manager.gd        # Core game state management
│   │   ├── quest_manager.gd       # Quest system
│   │   ├── inventory_manager.gd   # Inventory and equipment
│   │   ├── console_manager.gd     # Console commands
│   │   └── database_manager.gd    # Game data loading
│   ├── player/                    # Player-related scripts
│   │   ├── player_controller.gd   # Player movement and combat
│   │   └── abilities/             # Player abilities
│   ├── enemies/                   # Enemy/NPC scripts
│   │   └── enemy_controller.gd    # Base enemy AI
│   ├── ui/                        # UI scripts
│   │   ├── hud.gd                 # HUD display
│   │   ├── console_ui.gd          # Console UI
│   │   ├── inventory_ui.gd        # Inventory window
│   │   └── quest_log_ui.gd        # Quest log window
│   ├── screens/                   # Screen/area management
│   │   ├── screen_manager.gd      # Screen loading/transitions
│   │   └── game_world.gd          # Main world controller
│   └── resources/                 # Custom resource scripts
│       ├── player_class_data.gd   # Player class definitions
│       ├── enemy_data.gd          # Enemy definitions
│       └── screen_data.gd         # Screen/area definitions
│
├── resources/                     # Game data resources (.tres)
│   ├── player_classes/            # Player class data (12 classes)
│   ├── enemies/                   # Enemy data (70+ enemies)
│   ├── items/                     # Item data
│   ├── quests/                    # Quest definitions
│   ├── abilities/                 # Ability/skill data
│   └── screens/                   # Screen/area data (200 screens)
│
├── assets/                        # Game assets
│   ├── sprites/                   # 2D sprites from 3D renders
│   │   ├── characters/            # Character sprites
│   │   ├── enemies/               # Enemy sprites
│   │   └── items/                 # Item sprites
│   ├── backgrounds/               # Background images (200 screens)
│   ├── audio/                     # Sound effects and music
│   │   ├── music/                 # Background music
│   │   └── sfx/                   # Sound effects
│   └── ui/                        # UI assets
│
├── project.godot                  # Godot project file
├── readme.txt                     # Project design document
└── icon.svg                       # Project icon
```

## Key Systems

### Autoload Singletons
These scripts are automatically loaded and accessible globally:

- **GameManager**: Core game state, player stats, save/load
- **QuestManager**: Quest tracking and progression
- **InventoryManager**: Inventory and equipment management
- **ConsoleManager**: Developer console and cheat commands
- **DatabaseManager**: Loads and provides access to all game data
- **ScreenManager**: Handles screen transitions and entity spawning

### Player Classes (12 Total)
1. Bandit - Dual-wield, lockpick, +gold/attack speed
2. Death Knight - Necromancy, +harm touch damage
3. Enchanter - Transform, +vendor discount
4. Engineer - Mechanisms, +XP gain
5. Golem - Tank, +armor
6. Hero - Warrior, +damage
7. Huntsman - Ranged, +crit damage
8. Mage - Spells and pets, +mana
9. Monk - Hand-to-hand, +willpower
10. Lich - Undead pets, +poison/disease damage
11. Paladin - Hybrid healer/warrior, +healing
12. Tribalist - Traps and darts, +crit chance

### Enemy Types (70+ Total)
Categories include:
- Bandits
- Bears (normal, frost, cub/medium/large)
- Dinosaurs
- Dragons (dragonling, normal, turtle)
- Elementals (fire, earth, air)
- Ghosts (10 types)
- Giants
- Goblins
- Lizards
- Rats
- Scorpions
- Sirens
- Snakes
- Spiders (normal, frost)
- Vampires
- Wasps
- Werewolves
- Wolves
- Zombies

Each enemy type also has an NPC variant.

### Screen System
- 200 unique game screens/areas
- Each screen is a pre-rendered 3D background from Meshy.ai
- Screens connect left/right/up/down
- Each screen can have:
  - Enemy spawns
  - NPC spawns
  - Item pickups
  - Portals
  - Quest triggers

### Game Mechanics
- Health/Mana/Energy systems
- Experience and leveling
- Inventory and equipment (paper doll)
- Banking
- Quest log and tracking
- Console commands (cheat codes)
- Swimming mechanics
- Portal fast travel
- Rebirth system (prestige)
- Pet system
- Auction house (web integration)

## Next Steps

1. **Create Assets**: Generate sprites and backgrounds using Meshy.ai
2. **Build Screens**: Create all 200 screen resources with connections
3. **Implement Abilities**: Create ability system for each class
4. **Add Items**: Define weapons, armor, and consumables
5. **Create Quests**: Write quest chains and storylines
6. **Add Audio**: Music and sound effects
7. **Polish UI**: Improve UI visuals and UX
8. **Web Integration**: Build auction house website
9. **Testing**: Balance and bug fixing
10. **Release**: Prepare for distribution

## Development Notes

- All 3D assets are rendered to 2D sprites before import
- Use nearest-neighbor filtering for pixel-perfect scaling
- Keep sprite atlases organized by category
- Use resource files (.tres) for all game data
- Follow the existing naming conventions
- Document all major systems
