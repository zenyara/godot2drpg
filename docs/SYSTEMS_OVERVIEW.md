# EmpireRPG Systems Overview

## Core Systems Architecture

### GameManager (Autoload)
**Purpose**: Central hub for game state and player progress

**Responsibilities**:
- Player level, experience, and gold tracking
- Save/load game system
- Screen visit tracking
- Portal unlock system
- Game pause/resume
- Audio settings

**Key Methods**:
```gdscript
GameManager.start_new_game(class_name)
GameManager.add_experience(amount)
GameManager.add_gold(amount)
GameManager.save_game()
GameManager.load_game()
```

**Signals**:
- `player_died` - When player health reaches 0
- `level_changed(new_level)` - When player levels up
- `gold_changed(new_amount)` - When gold amount changes

---

### QuestManager (Autoload)
**Purpose**: Quest tracking and progression

**Quest Structure**:
```gdscript
{
    "id": "unique_quest_id",
    "name": "Display Name",
    "description": "Quest description",
    "type": "kill", # kill, collect, talk, explore, escort
    "objectives": [
        {
            "type": "kill",
            "target": "enemy_id",
            "required": 10,
            "current": 0
        }
    ],
    "rewards": {
        "exp": 100,
        "gold": 50,
        "items": ["item_id"]
    }
}
```

**Quest Types**:
1. **Kill**: Defeat X number of enemies
2. **Collect**: Gather X items
3. **Talk**: Speak with NPCs
4. **Explore**: Discover new areas
5. **Escort**: Protect NPC to destination

**Key Methods**:
```gdscript
QuestManager.start_quest(quest_id, quest_data)
QuestManager.on_enemy_killed(enemy_id)
QuestManager.on_item_collected(item_id, amount)
QuestManager.complete_quest(quest_id)
```

**Signals**:
- `quest_started(quest_id)`
- `quest_updated(quest_id, progress)`
- `quest_completed(quest_id)`
- `quest_failed(quest_id)`

---

### InventoryManager (Autoload)
**Purpose**: Item and equipment management

**Features**:
- Dynamic inventory (default 20 slots, expandable)
- Equipment slots (head, chest, legs, feet, hands, weapons, accessories)
- Pet equipment
- Banking system (50 slots)
- Item stacking
- Weight calculation (optional)

**Equipment Slots**:
- Head
- Chest
- Legs
- Feet
- Hands
- Main Hand Weapon
- Off Hand Weapon
- Accessory 1
- Accessory 2

**Pet Equipment**:
- Pet Armor
- Pet Accessory

**Key Methods**:
```gdscript
InventoryManager.add_item(item_id, amount, data)
InventoryManager.remove_item(item_id, amount)
InventoryManager.has_item(item_id, amount)
InventoryManager.equip_item(item_id, slot)
InventoryManager.transfer_to_bank(item_id, amount)
InventoryManager.expand_inventory(slots) # Perk shop
```

**Signals**:
- `inventory_changed`
- `equipment_changed(slot)`
- `item_added(item_id, amount)`
- `item_removed(item_id, amount)`

---

### ConsoleManager (Autoload)
**Purpose**: Developer console and debug commands

**Available Commands**:
- `help` - List all commands
- `die` - Kill player
- `exit` - Quit game
- `fly` - Toggle fly mode
- `give <item_id> [amount]` - Give item
- `god` - Toggle invincibility
- `idea <note>` - Add development note
- `kill` - Kill targeted NPC
- `killall` - Kill all nearby enemies
- `spawn <enemy_id>` - Spawn enemy
- `teleport <screen_id>` - Teleport to screen
- `addgold <amount>` - Add gold
- `addexp <amount>` - Add experience
- `setlevel <level>` - Set player level

**Key Methods**:
```gdscript
ConsoleManager.execute_command(input)
ConsoleManager.is_god_mode()
ConsoleManager.is_fly_mode()
```

**Usage**:
- Press ` (backtick) to toggle console
- Type command and press Enter
- Use Up/Down arrows for command history

---

### DatabaseManager (Autoload)
**Purpose**: Load and provide access to all game data

**Data Categories**:
1. **Player Classes** (12 classes)
2. **Enemies** (70+ types)
3. **Screens** (200 areas)
4. **Items** (weapons, armor, consumables)
5. **Quests**
6. **Abilities**

**Key Methods**:
```gdscript
DatabaseManager.get_player_class(class_id)
DatabaseManager.get_enemy(enemy_id)
DatabaseManager.get_screen(screen_id)
DatabaseManager.get_all_player_classes()
DatabaseManager.get_npcs_only()
DatabaseManager.get_hostiles_only()
```

**Auto-Generation**:
- Creates default data for all 12 classes
- Creates all enemy variants from readme.txt
- Generates placeholder screens (to be filled with real data)

---

### ScreenManager (Autoload)
**Purpose**: Manage 200+ game screens and transitions

**Screen Features**:
- Pre-rendered 3D backgrounds
- Connected screens (left, right, up, down)
- Enemy spawns with respawn timers
- NPC spawns (static)
- Item pickups
- Portal locations
- Environmental settings (music, weather, time of day)
- Swimming areas
- Quest triggers

**Screen Connections**:
```
[Screen 0] <---> [Screen 1] <---> [Screen 2]
     |                |                |
     v                v                v
[Screen 50]      [Screen 51]      [Screen 52]
```

**Key Methods**:
```gdscript
ScreenManager.load_screen(screen_id)
ScreenManager.transition_to_screen(direction) # "left", "right", "up", "down"
ScreenManager.is_at_screen_boundary(position, direction)
```

**Signals**:
- `screen_loaded(screen_id)`
- `screen_transition_started(from_id, to_id)`
- `screen_transition_completed(screen_id)`

---

## Player System

### Player Stats
- **Health**: Combat survivability
- **Mana**: Magic ability resource
- **Energy**: Physical ability resource (like WoW Rage)
- **Attack**: Damage output
- **Defense**: Damage reduction
- **Speed**: Movement speed
- **Attack Speed**: Attacks per second

### Stat Calculation
```
Final Stat = Base Stat (from class) 
           + Level Growth 
           + Equipment Bonuses 
           + Class Bonus %
```

### Class Bonuses
Each class gets unique passive bonuses:
- **Bandit**: +1% gold gain + +1% attack speed per level
- **Hero**: +1.5% damage per level
- **Engineer**: +1% XP gain per level
- **Huntsman**: +1% crit damage per level
- **Tribalist**: +1% crit chance per level
- *etc.*

### Player States
- Idle
- Moving
- Attacking
- Swimming
- Climbing
- Dying
- Dead

---

## Enemy/NPC System

### Enemy Types
1. **Hostile Enemies**: Aggressive, attack on sight
2. **Neutral Enemies**: Only attack if provoked
3. **Passive NPCs**: Never attack, provide services

### NPC Services
- **Quest Givers**: Start/complete quests
- **Vendors**: Buy/sell items
- **Bankers**: Access bank storage
- **Dialogue**: Lore and information

### Enemy AI States
- **Idle**: Standing still, random idle animations
- **Patrol**: Walking around spawn point
- **Chase**: Following player within range
- **Attack**: In combat with player
- **Flee**: Running away (low health)
- **Dead**: Defeated, drop loot

### Loot System
```gdscript
loot_table = [
    {"item_id": "gold_coin", "chance": 1.0, "min": 1, "max": 5},
    {"item_id": "health_potion", "chance": 0.2, "min": 1, "max": 1},
    {"item_id": "rare_drop", "chance": 0.05, "min": 1, "max": 1}
]
```

---

## Combat System

### Damage Calculation
```
Damage = Attacker.attack_power - Defender.defense
Actual Damage = max(1, Damage) # Minimum 1 damage
```

### Critical Hits
```
if randf() < crit_chance:
    damage *= (1.0 + crit_damage)
```

### Attack Cooldown
- Each attack has a cooldown based on attack_speed
- Cooldown = 1.0 / attack_speed

### Death and Respawn
- Player dies when health reaches 0
- Respawn at checkpoint/town
- Optional death penalty (gold loss, XP loss)
- NPCs respawn after timer

---

## Progression System

### Experience Formula
```
exp_for_next_level = 100 * (level ^ 1.5)
```

Example:
- Level 1→2: 100 XP
- Level 2→3: 283 XP
- Level 5→6: 1118 XP
- Level 10→11: 3162 XP

### Level Up Rewards
- All stats increase
- Health/Mana/Energy restored
- Class bonus increases
- Potential skill point (future feature)

### Rebirth System
- Reset to level 1
- Gain permanent stat bonus
- Unlock prestige ranks
- Keep special items (optional)

---

## UI System

### HUD (Heads-Up Display)
- Health bar
- Mana bar
- Energy bar
- Experience bar
- Level display
- Gold counter
- Quest tracker (active quests)

### Inventory Window
- Grid-based item display
- Equipment paper doll
- Item tooltips
- Drag-and-drop
- Sorting/filtering

### Quest Log Window
- Active quests list
- Quest details
- Objective tracking
- Reward preview

### Map Window
- Overworld map
- Discovered areas
- Portal locations
- Quest markers
- Player location

### Console Window
- Command input
- Output log
- Command history
- Auto-complete (future)

---

## Special Mechanics

### Swimming
- Required for water areas
- Slower movement speed
- Different animations
- Oxygen meter (optional)

### Climbing
- Ladders and ropes
- Vertical movement
- Can't attack while climbing

### Portals
- Fast travel between discovered locations
- Unlock by visiting
- Some require quests

### Pets
- Combat companions
- Can be equipped with gear
- Controllable or auto-attack
- Class-specific (Mage, Lich)

### Banking
- Store items remotely
- Access from banks in towns
- Limited slots (50 default)
- Shared between characters (optional)

---

## Future Systems (To Be Implemented)

### Ability/Skill System
- Multiple abilities per class
- Hotbar (1-9 keys)
- Cooldowns and mana costs
- Skill trees

### Crafting System
- Combine items to create new ones
- Profession system (blacksmith, alchemist)
- Recipe discovery

### Auction House (Web Integration)
- List items for sale
- Browse other players' items
- Bidding system
- Real-time sync with website

### Perks Shop (Monetization)
- Cosmetic items
- Inventory expansions
- Character slots
- Convenience items (non-pay-to-win)

### PvP System
- Designated PvP zones
- Dueling
- Arena battles

### Guild System
- Form guilds with other players
- Guild bank
- Guild quests
- Guild perks

---

## Performance Considerations

### Screen Caching
- Keep last 10 visited screens in cache
- Reduce loading times
- Memory management

### Entity Pooling
- Reuse enemy instances
- Reduce allocations
- Better performance

### Level of Detail (LOD)
- Reduce complexity for distant objects
- Limit active enemies per screen
- Optimize particle effects

---

## Data Flow Example

### Player Kills Enemy
1. Player attacks → Enemy takes damage
2. Enemy health ≤ 0 → Enemy.die()
3. Enemy drops gold → GameManager.add_gold()
4. Enemy drops XP → GameManager.add_experience()
5. GameManager checks level up → player levels up
6. Enemy drops loot → InventoryManager.add_item()
7. QuestManager.on_enemy_killed() → updates quests
8. Enemy removed after 3 seconds

### Player Completes Quest
1. Quest objective met → QuestManager.complete_quest()
2. Give rewards:
   - GameManager.add_experience()
   - GameManager.add_gold()
   - InventoryManager.add_item() for each reward
3. Update quest log UI
4. Show completion notification
5. Check for follow-up quests

---

## Development Workflow

1. **Design**: Plan feature in docs
2. **Implement**: Write code and create resources
3. **Test**: Use console commands for quick testing
4. **Iterate**: Refine based on testing
5. **Polish**: Add juice (particles, sounds, animations)
6. **Document**: Update documentation

## Testing Checklist

- [ ] Player movement responsive
- [ ] Combat feels good
- [ ] Quests track correctly
- [ ] Inventory works
- [ ] Screen transitions smooth
- [ ] No crashes or errors
- [ ] Save/load works
- [ ] Console commands functional
- [ ] UI is readable and responsive
- [ ] Performance acceptable (60 FPS)
