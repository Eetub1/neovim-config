## What you need before cloning this repo (atleast for linux)

- requires neovim 0.12 or newer
- sudo apt install ripgrep build-essential nodejs npm wl-clipboard
- rust/cargo to run the command "cargo install bob-nvim"
- setup some bob PATH??
- npm install -g tree-sitter-cli
- install JetBrainsMono font for working icons (or some other if you prefer)

Make sure everything works with :checkhealth

Neovim's C/C++ language server is clangd, which is clang-based. This config
makes clangd use g++'s headers and settings, so you can use `bits/stdc++.h`.

```bash
mkdir -p ~/.config/clangd
cat > ~/.config/clangd/config.yaml << 'EOF'
# C++ files: behave like g++ -std=c++17
If:
  PathMatch: .*\.(cpp|cc|cxx|hpp)
CompileFlags:
  Compiler: /usr/bin/g++
  Add: [-std=c++17]
---
# C files: behave like gcc
If:
  PathMatch: .*\.c
CompileFlags:
  Compiler: /usr/bin/gcc
EOF
```
