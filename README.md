# EmpireRPG - 2D Sidescroller RPG

A 2D sidescroller RPG built in **Godot 4.3**, inspired by [Murloc RPG](https://www.newgrounds.com/portal/view/339391) from Newgrounds. Features 200+ unique screens, 12 player classes, 70+ enemy types, and extensive RPG systems similar to WoW/EverQuest.

![Godot Version](https://img.shields.io/badge/Godot-4.3+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow.svg)

## 🎮 Project Overview

- **200 unique screens** - Pre-rendered 3D backgrounds from [Meshy.ai](https://www.meshy.ai/)
- **12 player classes** - Each with unique abilities and stat bonuses
- **70+ enemy types** - With variants (small/medium/large, elemental types, NPCs)
- **Quest system** - Multiple quest types (kill, collect, talk, explore, escort)
- **Full RPG systems** - Inventory, equipment, banking, console commands, save/load
- **2D sidescroller gameplay** - Classic side-scrolling with 3D-rendered sprites

## ✨ Features

### Core Systems (✅ Complete)
- ✅ **Player Controller** - Movement, combat, stats, class system
- ✅ **Enemy AI** - State machine (Idle, Patrol, Chase, Attack)
- ✅ **Quest Manager** - Track progress, rewards, multiple quest types
- ✅ **Inventory System** - Items, equipment, banking (9 character + 2 pet slots)
- ✅ **Screen Manager** - Handles 200+ area transitions
- ✅ **Console Commands** - God mode, fly, spawn, teleport, and more
- ✅ **Save/Load** - Persistent game state
- ✅ **Database Manager** - Auto-loads all classes, enemies, screens

### Player Classes (12 Total)
1. **Bandit** - Dual-wield, +gold/attack speed
2. **Death Knight** - Necromancy, +harm touch damage
3. **Enchanter** - Transform, +vendor discount
4. **Engineer** - Mechanisms, +XP gain
5. **Golem** - Tank, +armor
6. **Hero** - Warrior, +damage
7. **Huntsman** - Ranged, +crit damage
8. **Mage** - Spells/pets, +mana
9. **Monk** - Hand-to-hand, +willpower
10. **Lich** - Undead pets, +poison/disease
11. **Paladin** - Healer/warrior, +healing
12. **Tribalist** - Traps/darts, +crit chance

### Enemy Categories (70+ Types)
Bears • Dragons • Wolves • Zombies • Vampires • Giants • Goblins • Elementals • Spiders • Dinosaurs • Ghosts • and more...

## 🚀 Getting Started

### Prerequisites
- [Godot Engine 4.3+](https://godotengine.org/)
- [Meshy.ai Account](https://www.meshy.ai/) (for asset generation)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/zenyara/godot2drpg.git
   cd godot2drpg
   ```

2. **Open in Godot**
   - Launch Godot Engine
   - Click "Import"
   - Select `project.godot`

3. **Run the game**
   - Press **F5** to run
   - Press **`** (backtick) to open console

### Controls
- **Movement**: WASD or Arrow Keys
- **Attack**: Space or Left Mouse
- **Interact**: E
- **Inventory**: I
- **Quest Log**: L
- **Console**: ` (backtick)

### Console Commands
```
help          - List all commands
god           - Toggle invincibility
fly           - Toggle fly mode
addgold 1000  - Add gold
setlevel 10   - Set level
spawn rat     - Spawn enemy
teleport 5    - Go to screen 5
```

## 📁 Project Structure

```
empirerpg/
├── docs/              # Documentation
│   ├── GETTING_STARTED.md
│   ├── SYSTEMS_OVERVIEW.md
│   ├── MESHY_AI_WORKFLOW.md
│   └── PROJECT_STRUCTURE.md
├── scripts/           # All game code
│   ├── autoload/      # Singleton managers
│   ├── player/        # Player controller
│   ├── enemies/       # Enemy AI
│   ├── ui/            # UI scripts
│   └── resources/     # Data structures
├── scenes/            # Godot scenes
├── assets/            # Game assets (sprites, audio, backgrounds)
└── resources/         # Game data (.tres files)
```

## 📖 Documentation

- **[Getting Started Guide](docs/GETTING_STARTED.md)** - Setup and development
- **[Systems Overview](docs/SYSTEMS_OVERVIEW.md)** - Detailed system docs
- **[Meshy.ai Workflow](docs/MESHY_AI_WORKFLOW.md)** - Asset creation pipeline
- **[Project Structure](docs/PROJECT_STRUCTURE.md)** - Architecture guide
- **[TODO List](TODO.md)** - Development roadmap

## 🎨 Asset Pipeline

1. **Generate 3D models** in Meshy.ai
2. **Render to 2D sprites** in Blender
3. **Import to Godot** as sprite sheets
4. **Create resources** for enemies/classes/screens
5. **Test in-game** with console commands

See [MESHY_AI_WORKFLOW.md](docs/MESHY_AI_WORKFLOW.md) for detailed instructions.

## 🛠️ Development Status

### ✅ Phase 1: Foundation (COMPLETE)
- All core systems implemented
- All 12 classes defined
- All 70+ enemies created
- Full documentation written

### 🔄 Phase 2: Asset Creation (IN PROGRESS)
- [ ] Generate character models
- [ ] Generate enemy models
- [ ] Create 200 background screens
- [ ] Create animations

### ⏳ Phase 3: Content (TODO)
- [ ] Write quest chains
- [ ] Create items & equipment
- [ ] Design abilities
- [ ] Add audio

## 📊 Stats

- **Code Files**: 20+ GDScript files
- **Lines of Code**: 5,000+
- **Scenes**: 5 base scenes
- **Documentation**: 6 comprehensive guides
- **Development Time**: ~12 hours (foundation)

## 🤝 Contributing

This is a personal project, but feedback and suggestions are welcome!

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 Roadmap

- [x] Core systems implementation
- [x] Player class system
- [x] Enemy AI
- [x] Quest system
- [ ] Asset generation (200+ screens)
- [ ] Ability system
- [ ] Audio integration
- [ ] Web auction house
- [ ] Beta testing
- [ ] Release

## 🙏 Acknowledgments

- Inspired by [Murloc RPG](https://www.newgrounds.com/portal/view/339391)
- Built with [Godot Engine](https://godotengine.org/)
- Assets generated with [Meshy.ai](https://www.meshy.ai/)

---

**Status**: Foundation Complete ✅ | Asset Creation Phase 🎨

*A massive 2D sidescroller RPG with 200 screens, 12 classes, and 70+ enemies!*
