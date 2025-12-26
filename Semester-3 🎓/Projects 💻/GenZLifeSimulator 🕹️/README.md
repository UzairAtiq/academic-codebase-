# GenZ Life Simulator 🎮✨

**Author:** Muhammad Uzair Attiq  
**Enrollment:** 01-136242-029  
**Course:** Programming for Artificial Intelligence  
**Assignment:** #1

---

## 📖 Project Overview

The **GenZ Life Simulator** is an interactive Python-based chatbot and life simulation game that brings Gen Z culture to life! This project combines natural language processing with game mechanics to create an engaging experience where users can chat with a Gen Z-themed bot and simulate daily activities while managing virtual stats like energy, points, and mood.

The project demonstrates key programming concepts including:
- Function-based modular design
- Dictionary-based response systems
- Game loop mechanics and state management
- External API integration for dynamic content
- User input validation and control flow

### 🌟 What Makes It Special

- **Dual Mode Functionality:** Switch between casual chatting and gameplay seamlessly
- **Gen Z Authenticity:** Over 30 curated responses using modern slang and emojis
- **Dynamic Content:** Real-time anime quotes fetched from external API
- **Stat Management:** Track energy, points, and mood with visual feedback
- **Interactive Experience:** User-driven narrative with multiple activity paths

---

## 🚀 Setup Instructions

### Prerequisites

- **Python 3.7+** (Python 3.8 or higher recommended)
- **Jupyter Notebook** or **JupyterLab**
- **Internet Connection** (for anime quotes feature)

### Installation Steps

1. **Clone or Download the Project**
   ```bash
   cd /path/to/GenZLifeSimulator
   ```

2. **Install Required Dependencies**
   ```bash
   pip install requests
   ```
   
   Or install all dependencies at once:
   ```bash
   pip install jupyter requests
   ```

3. **Verify Installation**
   ```bash
   python -c "import requests; print('All dependencies installed!')"
   ```

### 🎯 Running the Project

#### Option 1: Using Jupyter Notebook (Recommended)

1. **Launch Jupyter Notebook**
   ```bash
   jupyter notebook
   ```

2. **Open the Notebook**
   - Navigate to `Chat Bot #1.ipynb` in the Jupyter interface

3. **Execute Cells in Order**
   - Run cells 1-10 to load all functions and definitions
   - Run cell 11 (the last cell) to start the interactive chatbot
   - Follow the on-screen prompts

#### Option 2: Using VS Code with Jupyter Extension

1. Open `Chat Bot #1.ipynb` in VS Code
2. Ensure Python kernel is selected
3. Click "Run All" or execute cells sequentially
4. Interact with the chatbot in the notebook output area

---

## 🎮 How It Works

### Architecture Overview

The project is organized into modular functions, each handling specific aspects of the chatbot and game:

```
┌─────────────────────────────────────────┐
│         Main Execution Loop             │
│     (Cell 11 - User Interaction)        │
└────────────┬────────────────────────────┘
             │
        ┌────┴────┐
        │         │
    ┌───▼──┐  ┌──▼────┐
    │ Chat │  │ Game  │
    │ Mode │  │ Mode  │
    └───┬──┘  └──┬────┘
        │        │
        │        └──────┬─────────────┬─────────────┬──────────┐
        │               │             │             │          │
    ┌───▼─────────┐ ┌──▼────┐  ┌────▼────┐  ┌─────▼───┐  ┌──▼──────┐
    │ getResponse │ │ Study │  │   Eat   │  │  Sleep  │  │  Anime  │
    └─────────────┘ └───────┘  └─────────┘  └─────────┘  └─────────┘
```

### Core Components

#### 1. **User Greeting System** (`greetUser()`)
- Welcomes users with Gen Z energy
- Collects user name and age
- Returns user data in a dictionary structure

#### 2. **Chat Response System** (`getResponse()`)
- Dictionary-based keyword matching
- 30+ pre-programmed Gen Z responses
- Fallback message for unrecognized inputs

#### 3. **Game Mechanics** (`mainGame()`)
- Initializes player stats (energy, points, mood)
- Activity-based stat modifications
- Continuous gameplay loop until exit

#### 4. **Stat Management** 
- **`updateStats()`**: Modifies stats based on chosen activity
- **`showStats()`**: Displays current player status
- **`endGame()`**: Shows final stats summary

#### 5. **Unique Feature** (`uniqueFeature()`)
- Fetches random anime quotes from external API
- Handles API failures gracefully with backup quotes
- Displays character names and wisdom

### Game Flow Diagram

```
START
  │
  ├─► Greet User (collect name & age)
  │
  ├─► Main Menu Loop
  │    │
  │    ├─► User types "bye" ───► End Chat ───► EXIT
  │    │
  │    ├─► User types "play" ───► Enter Game
  │    │                           │
  │    │                           ├─► Choose Activity
  │    │                           ├─► Update Stats
  │    │                           ├─► Show Feedback
  │    │                           └─► Loop until "exit"
  │    │
  │    └─► Any other input ───► Chat Response
  │                              │
  │                              └─► Loop back to Main Menu
  └─► Repeat until user exits
```

### Stat System Mechanics

| Activity | Energy Change | Points Change | Mood |
|----------|--------------|---------------|------|
| Study 📚 | -20 | +10 | 🙄 |
| Eat 🍕 | +15 | 0 | ☺️ |
| Play Games 🎮 | -10 | +5 | 😎 |
| Sleep 😴 | Reset to 100 | 0 | 😴 |
| Anime 🌸 | No change | No change | No change |
| Stats Display | No change | No change | No change |

---

## 🎯 Features

### Core Features

- ✅ **Interactive Chat System:** Engage with a Gen Z-themed chatbot with 30+ contextual responses
- ✅ **Life Simulation Game:** Choose and execute daily activities affecting your stats
- ✅ **Real-time Stats Tracking:** Monitor energy levels, points earned, and emotional mood
- ✅ **External API Integration:** Fetch random inspirational anime quotes dynamically
- ✅ **Dual-Mode Interface:** Seamlessly switch between chatting and gameplay
- ✅ **Error Handling:** Graceful degradation when API is unavailable

### Chat Responses Include

- Greetings (hello, good morning, good night)
- Emotions (happy, sad, angry, excited, tired)
- Reactions (wow, omg, lol, nice, cool)
- Interactions (thank you, sorry, love you, miss you)
- And many more Gen Z expressions!

---

## 💻 Technical Details

### Technology Stack

- **Language:** Python 3.x
- **Platform:** Jupyter Notebook (.ipynb)
- **External API:** [Yurippe Anime Quotes API](https://yurippe.vercel.app/)
- **Libraries Used:**
  - `requests` - HTTP requests for API calls
  - `random` - Random selection for anime quotes

### Code Structure

```
Chat Bot #1.ipynb
├── Cell 1: Project Header & Author Info
├── Cell 2: greetUser() - User greeting function
├── Cell 3: responses{} - Response dictionary
├── Cell 4: endChat() - Exit function
├── Cell 5: getResponse() - Chat response handler
├── Cell 6: showStats() - Stats display function
├── Cell 7: updateStats() - Stats update logic
├── Cell 8: endGame() - Game conclusion function
├── Cell 9: uniqueFeature() - API integration (with test call)
├── Cell 10: mainGame() - Game loop function
└── Cell 11: Main execution loop (START HERE)
```

### Key Programming Concepts Demonstrated

1. **Function Modularity:** Separation of concerns with dedicated functions
2. **Data Structures:** Dictionary usage for user data and responses
3. **Control Flow:** Nested loops and conditional statements
4. **API Integration:** External data fetching with error handling
5. **State Management:** Tracking and updating game variables
6. **User Input Handling:** Validation and processing of user commands

---

## 🎮 User Guide

### Starting the Application

1. Execute all cells in sequence (cells 1-10)
2. Run the final cell (cell 11) to start
3. Enter your name when prompted
4. Enter your age when prompted

### Chat Commands

Type any of these to get Gen Z responses:
- hello, hi, what's up
- good morning, good night
- thank you, sorry
- lol, omg, wow
- happy, sad, tired, excited
- And 20+ more expressions!

### Game Commands

When asked "What's the vibe today?":
- Type **"play"** to enter game mode
- Type **"bye"** to exit the application
- Type **any chat phrase** to continue chatting

### In-Game Commands

Once in the game, type:
- **"study"** - Study session
- **"eat"** - Eat food
- **"play games"** or **"game"** - Play video games
- **"sleep"** - Take a nap/sleep
- **"anime"** - Get anime wisdom quote
- **"stats"** - View current stats
- **"exit"** - End game and return to chat

---

## 📂 Project Files

| File | Description |
|------|-------------|
| `Chat Bot #1.ipynb` | Main notebook with all code implementation |
| `README.md` | Project documentation (this file) |
| `CHANGELOG.md` | Version history and updates |
| `version_control_explanation.txt` | Git and version control concepts |

---

## 🐛 Troubleshooting

### Common Issues

**Issue:** "Module 'requests' not found"
- **Solution:** Install requests: `pip install requests`

**Issue:** Anime quotes not loading
- **Solution:** Check internet connection. The app will show backup quotes if API fails.

**Issue:** Input prompts not appearing
- **Solution:** Ensure you're running cells in order (1-10, then 11)

**Issue:** Cells have no output
- **Solution:** Cells 1-8 are function definitions and won't show output. Only cells 9 and 11 produce visible output.

---

## 🔮 Future Enhancements

- [ ] Save/Load game progress
- [ ] Leaderboard system
- [ ] More activities and stat effects
- [ ] Multiplayer chat mode
- [ ] GUI version using Tkinter or PyQt
- [ ] Voice interaction capability
- [ ] Achievement system
- [ ] Day/night cycle mechanics

---

## 📜 License

This project is created for educational purposes as part of the Programming for Artificial Intelligence course.

---

## 🙏 Acknowledgments

- **Yurippe API** for providing anime quotes
- **Gen Z Culture** for the amazing slang and vibes
- **PAI Course** for the learning opportunity

---

## 📞 Contact

**Muhammad Uzair Attiq**  
Enrollment: 01-136242-029

---

*That's some main character energy right there! ✨*

---

*That's some main character energy right there! ✨*
