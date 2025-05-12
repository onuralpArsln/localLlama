#!/bin/bash

# Message history buffer
declare -a history=()
MAX_HISTORY=3

# Command menu
commands=("Check Time" "List Files" "Print Hello" "Exit")

# Trap Ctrl+C to exit cleanly
trap "tput cnorm; stty echo; clear; exit" INT

# Hide cursor
tput civis

# Function to print menu
command_menu() {
  local selected=0

  while true; do
    clear
    echo "Use ↑ ↓ arrows to navigate, ENTER to select:"
    for i in "${!commands[@]}"; do
      if [[ $i -eq $selected ]]; then
        echo -e "\e[1;36m> ${commands[$i]}\e[0m"
      else
        echo "  ${commands[$i]}"
      fi
    done

    read -rsn1 key
    if [[ $key == $'\x1b' ]]; then
      read -rsn2 -t 0.001 key2
      key+=$key2
    fi

    case $key in
      $'\x1b[A') ((selected--)); [ $selected -lt 0 ] && selected=$((${#commands[@]} - 1)) ;;
      $'\x1b[B') ((selected++)); [ $selected -ge ${#commands[@]} ] && selected=0 ;;
      "")  # Enter key
        clear
        echo "Command selected: ${commands[$selected]}"
        case $selected in
          0) echo "Time: $(date)" ;;
          1) ls -la ;;
          2) echo "Hello, user!" ;;
          3) echo "Exiting..."; tput cnorm; exit ;;
        esac
        read -p "Press enter to continue..." dummy
        break
        ;;
    esac
  done
}

# Function to print last 3 messages
show_history() {
  echo -e "\n🕘 Last ${#history[@]} message(s):"
  for msg in "${history[@]}"; do
    echo "- $msg"
  done
  echo
}

# MAIN LOOP
while true; do
  echo -en "\n📝 Enter something (or /commands or /history): "
  read -r input

  if [[ "$input" == "/commands" ]]; then
    command_menu
  elif [[ "$input" == "/history" ]]; then
    show_history
    read -p "Press enter to continue..." dummy
  elif [[ -n "$input" ]]; then
    echo "You said: $input"
    history+=("$input")

    # Trim history to max size
    if [ "${#history[@]}" -gt "$MAX_HISTORY" ]; then
      history=("${history[@]: -$MAX_HISTORY}")
    fi
  fi
done
