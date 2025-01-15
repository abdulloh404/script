#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script with root privileges (sudo)" >&2
  exit 1
fi

echo "📦 Starting installation of Zsh, Oh My Zsh, and plugins..."

# 1. Check if Zsh is installed
echo "🔧 Checking Zsh installation..."
if command -v zsh &> /dev/null; then
  echo "✅ Zsh is already installed at $(which zsh)."
else
  echo "🔧 Installing Zsh..."
  if [[ -x "$(command -v apt)" ]]; then
    apt update && apt install -y zsh
  elif [[ -x "$(command -v yum)" ]]; then
    yum install -y zsh
  elif [[ -x "$(command -v dnf)" ]]; then
    dnf install -y zsh
  elif [[ -x "$(command -v pacman)" ]]; then
    pacman -Syu --noconfirm zsh
  else
    echo "❌ Unable to install Zsh: No supported package manager found."
    exit 1
  fi
  echo "✅ Zsh installed successfully."
fi

# 2. Change default shell to Zsh if not already set
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "🔄 Changing default shell to Zsh..."
  chsh -s "$(which zsh)"
  if [[ $? -eq 0 ]]; then
    echo "✅ Default shell changed to Zsh."
  else
    echo "⚠️ Failed to change the default shell. You might need to do it manually."
  fi
else
  echo "✅ Default shell is already set to Zsh."
fi

# 3. Check if Oh My Zsh is installed
echo "✨ Checking Oh My Zsh installation..."
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "✅ Oh My Zsh is already installed at $HOME/.oh-my-zsh."
else
  echo "✨ Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "✅ Oh My Zsh installed successfully."
fi

# 4. Install Zsh plugins: zsh-syntax-highlighting and zsh-autosuggestions
echo "🔧 Installing Zsh plugins..."
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# zsh-autosuggestions
if [[ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGIN_DIR/zsh-autosuggestions"
  echo "✅ zsh-autosuggestions installed."
else
  echo "✅ zsh-autosuggestions is already installed."
fi

# zsh-syntax-highlighting
if [[ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGIN_DIR/zsh-syntax-highlighting"
  echo "✅ zsh-syntax-highlighting installed."
else
  echo "✅ zsh-syntax-highlighting is already installed."
fi

# Add plugins to .zshrc if not already present
echo "🔧 Configuring plugins in .zshrc..."
PLUGINS_LINE="plugins=(1password git zsh-autosuggestions zsh-syntax-highlighting z sudo urltools web-search copybuffer copypath copyfile dirhistory history macos nmap git-auto-fetch)"
if grep -q "^plugins=.*zsh-autosuggestions.*" "$HOME/.zshrc" && grep -q "^plugins=.*zsh-syntax-highlighting.*" "$HOME/.zshrc"; then
  echo "✅ Plugins are already configured in .zshrc."
else
  if grep -q "^plugins=" "$HOME/.zshrc"; then
    sed -i "/^plugins=/c\\$PLUGINS_LINE" "$HOME/.zshrc"
  else
    echo "$PLUGINS_LINE" >> "$HOME/.zshrc"
  fi
  echo "✅ Plugins added to .zshrc."
fi

echo "✅ Plugins configured in .zshrc."

# 6. Finish installation
echo "🎉 Installation process complete. Restart your terminal or run 'source ~/.zshrc' to apply the changes."
