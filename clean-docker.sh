#!/bin/bash

function clean_containers() {
  echo "Stopping and removing all containers..."
  docker ps -aq | xargs -r docker stop
  docker ps -aq | xargs -r docker rm
  echo "All containers cleaned!"
}

function clean_volumes() {
  echo "Removing all unused Docker volumes..."
  docker volume prune -f
  echo "All volumes cleaned!"
}

function clean_images() {
  echo "Removing all unused Docker images..."
  docker image prune -af
  echo "All images cleaned!"
}

function clean_cache() {
  echo "Removing all Docker build cache..."
  docker builder prune --all --force
  echo "Build cache cleaned!"
}

function clean_all() {
  echo "Performing a full system cleanup..."
  docker system prune --all --volumes --force
  echo "Full system cleanup completed!"
}

function show_menu() {
  echo "Docker Cleanup Menu:"
  echo "1. Clean Containers"
  echo "2. Clean Volumes"
  echo "3. Clean Images"
  echo "4. Clean Build Cache"
  echo "5. Clean Everything"
  echo "6. Exit"
}

while true; do
  show_menu
  read -p "Choose an option (1-6): " choice

  case $choice in
    1)
      clean_containers
      ;;
    2)
      clean_volumes
      ;;
    3)
      clean_images
      ;;
    4)
      clean_cache
      ;;
    5)
      clean_all
      ;;
    6)
      echo "Exiting..."
      break
      ;;
    *)
      echo "Invalid choice. Please enter a number between 1 and 6."
      ;;
  esac

  echo ""
done
