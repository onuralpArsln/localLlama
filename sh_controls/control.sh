#!/bin/bash

options=("Say Hello" "Show Date" "List Files" "Exit")
selected=0

# Hide cursor
tput civis

# Trap Ctrl+C to reset terminal
trap "tput cnorm; stty echo; clear; exit" INT

print_menu() {
  clear
  echo "Use ↑ ↓ arrows to navigate, ENTER to select"
  for i in "${!options[@]}"; do
    if [ $i -eq $selected ]; then
      # Highlight selection
      echo -e "\e[1;32m> ${options[$i]}\e[0m"
    else
      echo "  ${options[$i]}"
    fi
  done
}

while true; do
  print_menu

  # Read a single keypress
  read -rsn1 key

  # Handle arrow keys (multi-char sequences)
  if [[ $key == $'\x1b' ]]; then
    read -rsn2 -t 0.001 key2
    key+=$key2
  fi

  case $key in
    $'\x1b[A') # Up arrow
      ((selected--))
      [ $selected -lt 0 ] && selected=$((${#options[@]} - 1))
      ;;
    $'\x1b[B') # Down arrow
      ((selected++))
      [ $selected -ge ${#options[@]} ] && selected=0
      ;;
    "") # Enter key
      case $selected in
        0) echo "Hello, User!" ;;
        1) date ;;
        2) ls -la ;;
        3) echo "Exiting..."; break ;;
      esac
      read -p "Press enter to return..." dummy
      ;;
  esac
done

# Show cursor again
tput cnorm
clear
