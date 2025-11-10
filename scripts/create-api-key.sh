#!/bin/bash

# Script để tạo API key mới cho RiverFlow SMTP Server
# Usage: ./create-api-key.sh "Key Name" "Description"

SMTP_SERVER="https://river-flow-smtp-server.vercel.app"
MASTER_KEY="master-riverflow-smtp-key-2024"

# Get parameters
KEY_NAME="${1:-Production Server}"
KEY_DESCRIPTION="${2:-Main backend server}"

echo "🔑 Creating API Key for RiverFlow SMTP Server"
echo "=============================================="
echo ""
echo "Server: $SMTP_SERVER"
echo "Name: $KEY_NAME"
echo "Description: $KEY_DESCRIPTION"
echo ""

# Create API key
RESPONSE=$(curl -s -X POST "$SMTP_SERVER/api/keys" \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: $MASTER_KEY" \
  -d "{
    \"name\": \"$KEY_NAME\",
    \"description\": \"$KEY_DESCRIPTION\"
  }")

# Check if successful
if echo "$RESPONSE" | grep -q '"success":true'; then
  echo "✅ API Key created successfully!"
  echo ""
  echo "$RESPONSE" | jq '.'
  echo ""
  echo "⚠️  IMPORTANT: Save the 'key' value above securely!"
  echo "   You will not be able to see it again."
else
  echo "❌ Failed to create API key"
  echo ""
  echo "$RESPONSE" | jq '.'
  exit 1
fi

