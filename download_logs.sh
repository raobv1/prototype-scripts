#!/bin/bash

# Define the log group name
LOG_GROUP_NAME="/aws/lambda/my-function"  # Replace with your log group name

# Define a directory to store logs
LOG_DIR="./cloudwatch_logs"

# Create the directory if it doesn't exist
mkdir -p "$LOG_DIR"

# List all log streams in the log group
log_streams=$(aws logs describe-log-streams --log-group-name "$LOG_GROUP_NAME" --query "logStreams[].logStreamName" --output text --limit 5)

# Check if log streams are available
if [[ -z "$log_streams" ]]; then
  echo "No log streams found in log group: $LOG_GROUP_NAME"
  exit 1
fi

# Loop through each log stream and fetch the log events
for log_stream in $log_streams; do
  echo "Fetching logs for log stream: $log_stream"

  # Fetch log events for the current log stream and save them to a file
  aws logs filter-log-events \
    --log-group-name "$LOG_GROUP_NAME" \
    --log-stream-name "$log_stream" \
    --output text > "$LOG_DIR/$log_stream.txt"

  echo "Logs for log stream $log_stream saved to $LOG_DIR/$log_stream.txt"
done

echo "Log extraction complete."
