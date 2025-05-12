#!/bin/sh

while true; do
  echo "Select an option:"
  echo "1) Say Hello"
  echo "2) Show Date"
  echo "3) List Files"
  echo "4) Exit"
  echo -n "Enter your choice [1-4]: "
  read choice

  case "$choice" in
    1)
      echo "Hello, User!"
      ;;
    2)
      date
      ;;
    3)
      ls -la
      ;;
    4)
      echo "Exiting. Goodbye!"
      break
      ;;
    *)
      echo "Invalid choice. Please enter a number between 1 and 4."
      ;;
  esac

  echo ""  # print a newline
done
