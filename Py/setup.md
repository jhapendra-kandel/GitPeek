# GitPeek — Setup Guide

```
  ____ _ _   ____           _
 / ___(_) |_|  _ \ ___  ___| | __
| |  _| | __| |_) / _ \/ _ \ |/ /
| |_| | | |_|  __/  __/  __/   <
 \____|_|\__|_|   \___|\___|_|\_\

GitHub Repository Explorer  v2.1.0
```

---

## What is GitPeek?

GitPeek lets you explore any **public GitHub repository** without cloning it. Three interfaces are provided:

| Version | Description | Requires |
|---------|-------------|----------|
| **Web** | Browser-based, zero install | Any browser |
| **GUI** | Tkinter desktop app | Python 3.8 + tkinter |
| **CLI** | Terminal / headless | Python 3.8 |

---

## Quick Start (Auto Setup)

### Linux / macOS
```bash
git clone https://github.com/jhapendra-kandel/GitPeek.git
cd GitPeek
chmod +x setup.sh
./setup.sh
```

### Windows
```
git clone https://github.com/jhapendra-kandel/GitPeek.git
cd GitPeek
setup.bat
```

The script will:
1. Check Python 3.8+
2. Check / install tkinter
3. Create a `venv/` virtual environment
4. Install dependencies (`requests`, `rich`)
5. Create `gitpeek.sh` / `gitpeek.bat` launchers

---

## Manual Setup

### Prerequisites

| Requirement | Version | Notes |
|-------------|---------|-------|
| Python | 3.8+ | [python.org](https://python.org) |
| tkinter | any | Bundled on Win/macOS; Linux needs `python3-tk` |
| pip | 22+ | Comes with Python |

#### Install tkinter on Linux
```bash
# Ubuntu / Debian
sudo apt install python3-tk

# Fedora / RHEL
sudo dnf install python3-tkinter

# Arch Linux
sudo pacman -S tk
```

### Step 1 — Clone the repo
```bash
git clone https://github.com/jhapendra-kandel/GitPeek.git
cd GitPeek
```

### Step 2 — Create a virtual environment
```bash
python3 -m venv venv
```

### Step 3 — Activate the virtual environment
```bash
# Linux / macOS
source venv/bin/activate

# Windows CMD
venv\Scripts\activate.bat

# Windows PowerShell
venv\Scripts\Activate.ps1
```

### Step 4 — Install dependencies
```bash
pip install -r requirements.txt
```

---

## Running GitPeek

### Web Version
Simply open `index.html` in any browser — or deploy to GitHub Pages (no server needed).

```bash
# Quick preview (Python built-in server)
python3 -m http.server 8080
# Then open http://localhost:8080
```

### GUI Version (Tkinter)
```bash
python Py/GUI/main.py
```
Or use the launcher:
```bash
./gitpeek-gui.sh       # Linux/macOS
gitpeek-gui.bat        # Windows
```

### CLI Version
```bash
python Py/CLI/main.py
```
Or use the launcher:
```bash
./gitpeek.sh           # Linux/macOS
gitpeek.bat            # Windows
```

**One-shot commands (no REPL):**
```bash
# Load a repo and show the tree
./gitpeek.sh -r torvalds/linux tree 2

# View a specific file
./gitpeek.sh -r facebook/react cat README.md

# Search for Python files
./gitpeek.sh -r django/django search views.py
```

---

## CLI Commands Reference

```
load <owner/repo>       Load a GitHub repository
ls [path]               List files in directory
cd <path>               Change virtual directory (cd .. works)
tree [path] [depth]     Show file tree (default depth 3)
cat <file>              View file with syntax highlighting
head [-N] <file>        View first N lines (default 20)
search <query>          Search filenames
find <ext|pattern>      Find by extension or pattern
download <file> [out]   Download a file locally
fav <file>              Toggle file as favorite (⭐)
favls                   List your favorites
info [file]             Repo info or file info
stats                   File type statistics with bar chart
open [file]             Open repo/file on GitHub in browser
history                 Show recently loaded repos
clear                   Clear the screen
help                    Show all commands
quit / exit             Exit GitPeek
```

---

## GUI Features

| Feature | How to use |
|---------|-----------|
| Load repo | Paste URL in top bar → Enter or click Load |
| Browse files | Double-click any file in the tree |
| HTML Preview | Opens auto-split: code left, rendered right |
| Markdown Preview | Opens auto-split: source left, rendered right |
| CSS Injection | Toggle `CSS: ON/OFF` button — fetches `<link>` CSS from repo |
| View mode | Split / Code Only / Preview Only radio buttons |
| Batch download | Check files → click "⬇ Download Selected" → choose folder |
| Favorites | Click ⭐ in pane header — persisted to `~/.gitpeek/` |
| Split view | Ctrl+\ — opens second pane (Ctrl+Click tree item) |
| Search | Ctrl+K — opens search panel |
| Navigate | ← → arrow keys cycle through files |
| Theme | ◑ Theme button — Dark / Light toggle |
| Download file | ⬇ button in pane header |
| Open on GitHub | ↗ button in pane header |

---

## Web Version Features

Same as GUI, plus:

- **Deep linking** — Share a URL that opens a specific file
- **Drag & Drop** — Drop a GitHub URL onto the page
- **Offline cache** — Recently viewed files cached in browser
- **Keyboard shortcuts** — Full keyboard navigation
- **Rate limit badge** — Shows remaining GitHub API calls
- **Mobile** — Swipe gestures, responsive layout

---

## GitHub API Rate Limits

| Auth status | Limit |
|-------------|-------|
| Unauthenticated | 60 requests / hour |
| Authenticated (token) | 5,000 requests / hour |

### Set a GitHub Token
```bash
# Linux / macOS (add to ~/.bashrc or ~/.zshrc)
export GITHUB_TOKEN=ghp_YourPersonalAccessTokenHere

# Windows CMD (session)
set GITHUB_TOKEN=ghp_YourPersonalAccessTokenHere

# Windows PowerShell (session)
$env:GITHUB_TOKEN = "ghp_YourPersonalAccessTokenHere"
```

Create a token at: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**

Required scopes: **none** (public repos only) or `repo` for private repos.

---

## Project Structure

```
GitPeek/
├── index.html          # Web app shell
├── style.css           # Web app styles
├── script.js           # Web app logic
├── Images/
│   └── Logo.png        # App logo
├── Py/
│   ├── GUI/
│   │   └── main.py     # Tkinter GUI app
│   └── CLI/
│       └── main.py     # CLI / headless app
├── requirements.txt    # Python dependencies
├── setup.sh            # Linux/macOS auto-setup
├── setup.bat           # Windows auto-setup
├── SETUP.md            # This file
├── README.md           # Project readme
└── LICENSE             # MIT License
```

---

## Troubleshooting

### "tkinter not found"
```bash
# Ubuntu/Debian
sudo apt install python3-tk

# macOS (Homebrew)
brew install python-tk
```

### "GitHub API rate limit exceeded"
Set the `GITHUB_TOKEN` environment variable (see above).

### "Repository not found"
Make sure the repository is **public**. Private repos require a token with `repo` scope.

### "SSL Certificate error" (corporate networks)
```bash
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org requests
```

### CLI colors not showing
Install `rich`:
```bash
pip install rich
```

### Web version not loading local files
Use a local server — browsers block `file://` fetch requests:
```bash
python3 -m http.server 8080
```

---

## Dependencies

| Package | Purpose | Required |
|---------|---------|----------|
| `requests` | HTTP requests | Recommended (urllib fallback exists) |
| `rich` | CLI colors & formatting | Optional (plain text fallback) |
| `Pillow` | Image preview in GUI | Optional |
| `tkinter` | GUI framework | Required for GUI only |

---

## License

MIT © Jhapendra Kandel (J.K)