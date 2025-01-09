#!/bin/bash

start_services() {
  echo "Starting Nginx..."
  sudo systemctl start nginx
  echo "Nginx Started: $(sudo systemctl is-active nginx)"
  
  echo "Starting MySQL..."
  sudo systemctl start mysql
  echo "MySQL Started: $(sudo systemctl is-active mysql)"
  
  echo "Starting PHP-FPM..."
  sudo systemctl start php8.3-fpm
  echo "PHP-FPM Started: $(sudo systemctl is-active php8.3-fpm)"
}

# ฟังก์ชันหยุดบริการ
stop_services() {
  echo "Stopping Nginx..."
  sudo systemctl stop nginx
  echo "Nginx Stopped: $(sudo systemctl is-active nginx)"
  
  echo "Stopping MySQL..."
  sudo systemctl stop mysql
  echo "MySQL Stopped: $(sudo systemctl is-active mysql)"
  
  echo "Stopping PHP-FPM..."
  sudo systemctl stop php8.3-fpm
  echo "PHP-FPM Stopped: $(sudo systemctl is-active php8.3-fpm)"
}

restart_services() {
  stop_services
  start_services
}

start_services

while true; do
  echo "Press Control+R to restart services, or Control+C to stop and exit."

  read -rsn1 key # รอการกดปุ่ม
  if [[ $key == $'\x12' ]]; then # ตรวจจับ Control+R (Restart)
    echo "Restarting services..."
    restart_services
  elif [[ $key == $'\x03' ]]; then # ตรวจจับ Control+C (Stop and Exit)
    echo "Stopping services and exiting..."
    stop_services
    exit 0
  else
    echo "Invalid key. Only Control+R and Control+C are allowed."
  fi
done
