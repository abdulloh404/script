#!/bin/bash

LOG_FILE="/tmp/service_status.log"

# ฟังก์ชันตรวจสอบสถานะ
check_service_status() {
  local service=$1
  local port=$2
  local status=$(sudo systemctl is-active $service)
  local pid=$(pgrep -x "$service")
  local log_path="/var/log/$service/access.log"

  if [[ $status == "active" ]]; then
    echo -e "  🟢 $service Started"
    echo -e "     Status: active"
    echo -e "     Port: $port"
    echo -e "     Logs: $log_path"
  else
    echo -e "  🔴 $service Stopped"
    echo -e "     Status: inactive"
  fi
}

# ฟังก์ชันเริ่มต้นบริการ
start_services() {
  echo "Executing Command: sudo systemctl start services"
  echo -e "  🔧 Processing...\n"

  sudo systemctl start nginx
  sudo systemctl start mysql
  sudo systemctl start php8.4-fpm

  echo -e "info: Systemd[14]"
  check_service_status "nginx" "http://localhost:8080"
  check_service_status "mysql" "3306"
  check_service_status "php8.4-fpm" "Unknown"

  echo -e "info: Systemd[0]"
  echo -e "     Press Ctrl+C to shut down monitoring."
  echo -e "     Press Ctrl+R to restart monitoring."
  echo -e "     Press Ctrl+L to log monitoring."
}

# ฟังก์ชันรีสตาร์ทบริการ
restart_services() {
  echo "Executing Command: sudo systemctl restart services"
  echo -e "  🔧 Restarting...\n"

  sudo systemctl restart nginx
  sudo systemctl restart mysql
  sudo systemctl restart php8.4-fpm

  echo -e "info: Systemd[14]"
  check_service_status "nginx" "http://localhost:8080"
  check_service_status "mysql" "3306"
  check_service_status "php8.4-fpm" "Unknown"

  echo -e "info: Systemd[0]"
  echo -e "     Press Ctrl+C to shut down monitoring."
  echo -e "     Press Ctrl+R to restart monitoring."
  echo -e "     Press Ctrl+L to log monitoring."
}

# ฟังก์ชันแสดง Log
log_services() {
  echo -e "\ninfo: Logs"
  tail -n 10 /var/log/nginx/access.log
  tail -n 10 /var/log/mysql/error.log
  tail -n 10 /var/log/php8.4-fpm.log
}

# ฟังก์ชันเริ่มต้นการทำงาน
start_services

# รอการกดปุ่ม
while true; do
  read -rsn1 key
  if [[ $key == $'\x12' ]]; then # Control+R
    restart_services
  elif [[ $key == $'\x03' ]]; then # Control+C
    echo -e "\nStopping services and exiting..."
    exit 0
  elif [[ $key == $'\x0C' ]]; then # Control+L
    log_services
  fi
done
