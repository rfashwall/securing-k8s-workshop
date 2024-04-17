#!/bin/bash

tools=(kubectl kind helm docker git go)

for tool in "${tools[@]}"; do
  if command -v "$tool" &>/dev/null; then
    echo "✅ $tool is already installed" 
  else
    echo "⚠️  $tool is not installed. Attempting to install..."
    
    case "$(uname -s)" in
       Linux)
          if command -v apt-get &>/dev/null; then
             sudo apt-get update
             sudo apt-get install -y "$tool"
          fi
          ;;

       Darwin)  # macOS
          if command -v brew &>/dev/null; then
             brew install "$tool"
          else
             echo "Homebrew not found. Please install Homebrew first."
          fi
          ;;

       *)
          echo "Unsupported operating system. Please install $tool manually."
          ;;
    esac
  fi
done
