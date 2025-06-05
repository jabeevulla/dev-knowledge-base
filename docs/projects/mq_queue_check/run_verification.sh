#!/bin/bash

# --- Configurable ---
QMGR_NAME=${2:-QM1}
DELIMITER=${3:-,}
TEMPLATE="verify_queue_config.mqsc.template"
SCRIPT_DIR="scripts"
LOG_DIR="output"
SUMMARY_FILE="$LOG_DIR/summary_report_$(date +%Y%m%d_%H%M%S).log"

# --- Ensure dirs ---
mkdir -p "$LOG_DIR" "$SCRIPT_DIR"

# --- Split the queue list ---
IFS="$DELIMITER" read -ra QUEUE_ARRAY <<< "$1"

# --- Init summary ---
echo "IBM MQ Queue Configuration Summary Report" > "$SUMMARY_FILE"
echo "Queue Manager: $QMGR_NAME" >> "$SUMMARY_FILE"
echo "Generated: $(date)" >> "$SUMMARY_FILE"
echo "------------------------------------------" >> "$SUMMARY_FILE"

# --- Loop through queues ---
for QUEUE_NAME in "${QUEUE_ARRAY[@]}"; do
  SCRIPT_FILE="$SCRIPT_DIR/verify_${QUEUE_NAME}.mqsc"
  LOGFILE="$LOG_DIR/${QUEUE_NAME}_mq_config_check_$(date +%Y%m%d_%H%M%S).log"

  echo "🔍 Verifying queue: $QUEUE_NAME"

  # Generate MQSC script
  cp "$TEMPLATE" "$SCRIPT_FILE"
  sed -i '' "s/{QUEUE_NAME}/$QUEUE_NAME/g" "$SCRIPT_FILE"

  # Run MQSC and save output
  docker exec -i ibm-mq runmqsc "$QMGR_NAME" < "$SCRIPT_FILE" > "$LOGFILE"

  # Analyze & append to summary
  {
    echo ""
    echo "Queue: $QUEUE_NAME"
    echo "----------------------------------"
    grep -E "BOQNAME\(\)|BOTHRESH\(0\)|DEFPSIST\(NO\)|MAXDEPTH\(0\)|MAXMSGL\(0\)|DEADQ\(\)" "$LOGFILE" | while read -r line; do
      echo "⚠️  Potential issue: $line"
    done
    echo "✅ Full log: $LOGFILE"
  } >> "$SUMMARY_FILE"

done

# --- Done ---
echo -e "\n✅ All queue checks completed."
echo "📄 Summary report saved to: $SUMMARY_FILE"