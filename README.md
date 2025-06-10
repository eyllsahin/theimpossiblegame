# The Impossible Game

## Overview
The Impossible Game is a 2D educational fighting game built with Godot Engine. Players choose between two characters, Graviton and Quanta, each representing fundamental physics concepts. The game combines classic fighting mechanics with interactive educational content, making learning about quantum mechanics and gravity engaging and fun.

## Features
- **Character Selection:** Choose between Graviton (gravity-based) and Quanta (quantum-based) fighters.
- **Educational Content:** Each character has a dedicated learning section with interactive videos explaining core scientific concepts.
- **Classic Fighting Mechanics:** Punch, kick, jump, and block your way to victory against AI opponents.
- **Stylized Visuals:** Custom animations and backgrounds for each character and scene.
- **Accessible Controls:** Simple keyboard controls for movement and attacks.

## Project Structure
- `scenes/` — Godot scene files for menus, character selection, learning, and fighting.
- `scripts/` — GDScript files for game logic, character behavior, UI, and educational content.
- `game/` — Character sprites, animations, and backgrounds.
- `learnquanta/` and `learngraviton/` — Educational video assets for each character.
- `startmenu/`, `characterselection/`, `options/` — UI assets and supporting files.

## Setup Instructions
1. **Install Godot Engine** (version 4.4 or compatible).
2. **Clone this repository**:
   ```
   git clone <your-repo-url>
   ```
3. **Open the project** in Godot by selecting the `project.godot` file.
4. **Run the game** by pressing F5 or clicking the Run button in the Godot editor.

## Controls
| Action         | Key         |
| -------------- | ----------- |
| Move Left      | Left Arrow  |
| Move Right     | Right Arrow |
| Jump           | Enter       |
| Punch          | A           |
| Kick           | S           |

## Gameplay
- **Main Menu:** Start the game, access options, or exit.
- **Character Selection:** Choose Graviton or Quanta, or access their learning modules.
- **Learning Modules:** Watch short, interactive videos about quantum mechanics (Quanta) or gravity (Graviton).
- **Fight Scene:** Battle the AI-controlled opponent using your character's unique abilities. Health bars and labels indicate player and enemy status. The camera dynamically follows the action.
- **Game Over:** After a win or loss, return to character selection.

## Credits
- **Programming & Design:** [Your Name]
- **Art & Animation:** [Your Name/Team]
- **Educational Content:** [Your Name/Team]
- **Engine:** Godot Engine

## License
[Specify your license here] 