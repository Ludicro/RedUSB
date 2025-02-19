#!/bin/bash
while true; do
    clear
    echo "System Tools Menu"
    echo "================"
    echo "1. Future Linux Tool"
    echo "2. Exit"
    read -p "Select option: " choice
    
    case $choice in
        1) echo "Linux tool placeholder";;
        2) exit 0;;
    esac
    read -p "Press enter to continue..."
done
