#!/bin/bash

# Set the service name to monitor
SERVICE_NAME=${SERVICE_NAME:-web}

# Set the CPU and memory thresholds
CPU_THRESHOLD=${CPU_THRESHOLD:-80}
MEMORY_THRESHOLD=${MEMORY_THRESHOLD:-80}

# Get the ID of the service container
#CONTAINER_ID=$(docker service ps -f "desired-state=running" -f "name=$SERVICE_NAME" --format "{{.ID}}")

# Function to get CPU usage percentage
get_cpu_usage() {
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}" "$SERVICE_NAME" | tail -n +2 | awk '{print $2}' | cut -d'%' -f1
}

# Function to get memory usage percentage
get_memory_usage() {
    docker stats --no-stream --format "table {{.Name}}\t{{.MemPerc}}" "$SERVICE_NAME" | tail -n +2 | awk '{print $2}' | cut -d'%' -f1
}

# Main loop
while true; do
    CPU_USAGE=$(get_cpu_usage)
    MEMORY_USAGE=$(get_memory_usage)

    echo "CPU Usage: $CPU_USAGE%, Memory Usage: $MEMORY_USAGE%"

    # Check if CPU or memory usage exceeds thresholds
#    if (( $(echo "$CPU_USAGE >= $CPU_THRESHOLD" | bc -l) )) || (( $(echo "$MEMORY_USAGE >= $MEMORY_THRESHOLD" | bc -l) )); then
#        echo "Scaling $SERVICE_NAME..."
#        docker service scale "$SERVICE_NAME"=$(( $(docker service inspect --format '{{.Mode.Replicated.Replicas}}' "$SERVICE_NAME") + 1 ))
#    fi

    sleep 60  # Check every minute
done
