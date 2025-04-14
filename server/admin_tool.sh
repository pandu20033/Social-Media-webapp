#!/bin/bash

# Function to prompt the user to exit or continue
prompt_exit() {
  read -p "Press Enter to continue, or 'c' to exit..."
  if [[ "$REPLY" == "c" || "$REPLY" == "C" ]]; then
    echo "Exiting..."
    exit
  fi
}

while true; do
  # Display menu options
  echo "What would you like to do? (Enter the number)"
  echo "1. Create an admin"
  echo "2. Add communities and rules to the database"
  echo "3. Add rules to communities"
  echo "4. Add moderators to communities (also available from the admin panel)"
  echo "5. Remove moderators from communities (also available from the admin panel)"
  echo "Press 'c' and Enter to exit or any other key to continue..."
  
  read choice
  
  # Validate input
  if ! [[ "$choice" =~ ^[1-5cC]$ ]]; then
    echo "Invalid input, please try again."
    continue
  fi
  
  # Handle menu selection
  case $choice in
    1)
      echo "Executing create-admin.js..."
      if [[ -f "scripts/create-admin.js" ]]; then
        if ! node "scripts/create-admin.js"; then
          echo "Error executing create-admin.js. Check the file for issues."
        fi
      else
        echo "Error: scripts/create-admin.js not found!"
      fi
      prompt_exit
      ;;
    2)
      echo "Executing add-community.js..."
      if [[ -f "scripts/add-community.js" ]]; then
        if ! node "scripts/add-community.js"; then
          echo "Error executing add-community.js. Check the file for issues."
        fi
      else
        echo "Error: scripts/add-community.js not found!"
      fi
      prompt_exit
      ;;
    3)
      echo "Executing add-rules.js..."
      if [[ -f "scripts/add-rules.js" ]]; then
        if ! node "scripts/add-rules.js"; then
          echo "Error executing add-rules.js. Check the file for issues."
        fi
      else
        echo "Error: scripts/add-rules.js not found!"
      fi
      prompt_exit
      ;;
    4)
      echo "Executing add-moderator.js..."
      if [[ -f "scripts/add-moderator.js" ]]; then
        if ! node "scripts/add-moderator.js"; then
          echo "Error executing add-moderator.js. Check the file for issues."
        fi
      else
        echo "Error: scripts/add-moderator.js not found!"
      fi
      prompt_exit
      ;;
    5)
      echo "Executing remove-moderator.js..."
      if [[ -f "scripts/remove-moderator.js" ]]; then
        if ! node "scripts/remove-moderator.js"; then
          echo "Error executing remove-moderator.js. Check the file for issues."
        fi
      else
        echo "Error: scripts/remove-moderator.js not found!"
      fi
      prompt_exit
      ;;
    c|C)
      echo "Exiting..."
      exit
      ;;
    *)
      echo "Invalid input, please try again."
      ;;
  esac
done