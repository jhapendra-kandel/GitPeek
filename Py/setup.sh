#!/usr/bin/env bash
# ================================================================
# GitPeek — Automatic Setup Script (Linux / macOS)
# ================================================================
# Usage:
#   chmod +x setup.sh && ./setup.sh
# ================================================================

set -e   # Exit on first error

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

banner() {
  echo -e "${CYAN}"
  echo '  ____ _ _   ____           _      '
  echo ' / ___(_) |_|  _ \ ___  ___| | __  '
  echo '| |  _| | __| |_) / _ \/ _ \ |/ /  '
  echo '| |_| | | |_|  __/  __/  __/   <   '
  echo ' \____|_|\__|_|   \___|\___|_|\_\   '
  echo -e "${RESET}"
  echo -e "${BOLD}GitPeek — GitHub Repository Explorer${RESET}"
  echo -e "${CYAN}Setup Script v2.1.0${RESET}"
  echo
}

ok()   { echo -e "  ${GREEN}✓${RESET}  $*"; }
warn() { echo -e "  ${YELLOW}⚠${RESET}  $*"; }
err()  { echo -e "  ${RED}✗${RESET}  $*"; exit 1; }
info() { echo -e "  ${CYAN}ℹ${RESET}  $*"; }
step() { echo -e "\n${BOLD}── $* ──${RESET}"; }

# ── 1. Check Python ───────────────────────────────────────────────
banner
step "Checking Python"

PYTHON=""
for cmd in python3 python; do
  if command -v "$cmd" &>/dev/null; then
    VER=$("$cmd" -c 'import sys; print(sys.version_info[:2])' 2>/dev/null)
    if "$cmd" -c 'import sys; sys.exit(0 if sys.version_info >= (3,8) else 1)' 2>/dev/null; then
      PYTHON="$cmd"
      ok "Found $("$cmd" --version)"
      break
    else
      warn "$cmd found but version is too old (need 3.8+): $("$cmd" --version 2>&1)"
    fi
  fi
done

[ -z "$PYTHON" ] && err "Python 3.8+ not found. Install from https://python.org"

# ── 2. Check tkinter (for GUI) ────────────────────────────────────
step "Checking tkinter (for GUI)"
if "$PYTHON" -c "import tkinter" 2>/dev/null; then
  ok "tkinter is available"
else
  warn "tkinter not found. Installing…"
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y python3-tk && ok "tkinter installed via apt"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y python3-tkinter && ok "tkinter installed via dnf"
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm tk && ok "tkinter installed via pacman"
  elif command -v brew &>/dev/null; then
    brew install python-tk && ok "tkinter installed via brew"
  else
    warn "Could not auto-install tkinter. Install it manually:"
    warn "  Ubuntu/Debian: sudo apt install python3-tk"
    warn "  Fedora:        sudo dnf install python3-tkinter"
    warn "  Arch:          sudo pacman -S tk"
    warn "  macOS:         brew install python-tk"
    warn "CLI version will still work without tkinter."
  fi
fi

# ── 3. Create virtual environment ─────────────────────────────────
step "Creating virtual environment"
VENV_DIR="venv"
if [ -d "$VENV_DIR" ]; then
  warn "venv/ already exists — skipping creation"
else
  "$PYTHON" -m venv "$VENV_DIR"
  ok "Virtual environment created in $VENV_DIR/"
fi

# Activate
source "$VENV_DIR/bin/activate"
ok "Virtual environment activated"

# ── 4. Upgrade pip ────────────────────────────────────────────────
step "Upgrading pip"
pip install --upgrade pip --quiet && ok "pip up-to-date"

# ── 5. Install dependencies ───────────────────────────────────────
step "Installing dependencies"
pip install -r requirements.txt --quiet && ok "Dependencies installed"

# ── 6. Create launcher scripts ────────────────────────────────────
step "Creating launcher scripts"

# GUI launcher
cat > gitpeek-gui.sh << 'EOF'
#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/venv/bin/activate"
python "$DIR/Py/GUI/main.py" "$@"
EOF
chmod +x gitpeek-gui.sh
ok "Created gitpeek-gui.sh"

# CLI launcher
cat > gitpeek.sh << 'EOF'
#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/venv/bin/activate"
python "$DIR/Py/CLI/main.py" "$@"
EOF
chmod +x gitpeek.sh
ok "Created gitpeek.sh"

# ── 7. Optional: symlink to /usr/local/bin ────────────────────────
step "System PATH integration (optional)"
ABS_CLI="$(pwd)/gitpeek.sh"
if [ -w /usr/local/bin ]; then
  ln -sf "$ABS_CLI" /usr/local/bin/gitpeek && ok "Linked gitpeek → /usr/local/bin/gitpeek"
else
  info "To add 'gitpeek' to PATH globally, run:"
  info "  sudo ln -sf $(pwd)/gitpeek.sh /usr/local/bin/gitpeek"
fi

# ── 8. Summary ────────────────────────────────────────────────────
echo
echo -e "${GREEN}${BOLD}════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  Setup Complete! 🎉${RESET}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════${RESET}"
echo
echo -e "  ${BOLD}Run CLI:${RESET}  ./gitpeek.sh"
echo -e "  ${BOLD}Run GUI:${RESET}  ./gitpeek-gui.sh"
echo -e "  ${BOLD}Quick:${RESET}   ./gitpeek.sh -r torvalds/linux tree 2"
echo
echo -e "  ${CYAN}Set your GitHub token for higher rate limits:${RESET}"
echo -e "  export GITHUB_TOKEN=ghp_yourtoken"
echo
echo -e "  ${CYAN}Read the setup guide:${RESET}  cat SETUP.md"
echo