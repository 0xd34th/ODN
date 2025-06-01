#!/usr/bin/env bash
set -euo pipefail

PACKAGE_ID="0xa22bce3a0ecea9077aa65405ec7f0dfab82064cba98d8b2413950da44c898a44"
MODULE="traits"
LOG_FILE="upload_ids.log"
: > "$LOG_FILE"

# GAS_BUDGET="--gas-budget 500000000"   # optional

call_and_log() {
  local part_type="$1"; shift
  local idx="$1";       shift
  local func="$1";      shift
  local args=("$@")

  echo " • ${part_type}_${idx} …"

  local out
  if ! out="$(sui client call \
                --json \
                --package "$PACKAGE_ID" \
                --module  "$MODULE" \
                --function "$func" \
                --args   "${args[@]}" \
                ${GAS_BUDGET:-})"
  then
    echo "❌  ${part_type}_${idx} failed" >&2
    exit 1
  fi

  local obj_id
  obj_id="$(echo "$out" | jq -r '.effects.created[0].reference.objectId')"
  echo "${part_type},${idx},${obj_id}" >> "$LOG_FILE"
}

upload_helmet() {
  local idx="$1"
  local base="helmet_${idx}"
  call_and_log "helmet" "$idx" "upload_helmet" \
    "$(cat "${base}_part0.txt")" "$(cat "${base}_part1.txt")"
}

upload_stomach() {
  local idx="$1"
  local base="stomach_${idx}"
  call_and_log "stomach" "$idx" "upload_stomach" \
    "$(cat "${base}_part0.txt")" "$(cat "${base}_part1.txt")"
}

upload_body() {
  local idx="$1"
  local base="body_${idx}"
  call_and_log "body" "$idx" "upload_body" \
    "$(cat "${base}_part0.txt")" "$(cat "${base}_part1.txt")" \
    "$(cat "${base}_part2.txt")" "$(cat "${base}_part3.txt")"
}

upload_wings() {
  local idx="$1"
  local base="wing_${idx}"
  call_and_log "wing" "$idx" "upload_wings" \
    "$(cat "${base}_part0.txt")" "$(cat "${base}_part1.txt")" \
    "$(cat "${base}_part2.txt")" "$(cat "${base}_part3.txt")" \
    "$(cat "${base}_part4.txt")" "$(cat "${base}_part5.txt")"
}

echo "Uploading helmets…"
for i in $(seq -w 01 10); do upload_helmet "$i"; done

echo "Uploading stomachs…"
for i in $(seq -w 01 10); do upload_stomach "$i"; done

echo "Uploading bodies…"
for i in $(seq -w 01 10); do upload_body "$i"; done

echo "Uploading wings…"
for i in $(seq -w 01 10); do upload_wings "$i"; done

echo "✅  All parts uploaded — IDs logged to $LOG_FILE"
