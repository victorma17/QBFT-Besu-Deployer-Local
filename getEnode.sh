#!/bin/bash

# Obtain the enode from the bootnode and update configValidators.toml
echo "Obtaining enodes.."
ENODE=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H "Content-Type: application/json" localhost:8545 | jq -r '.result[0].enode')
if [ -z "$ENODE" ] || [[ "$ENODE" == "null" ]]; then
  ENODE=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H "Content-Type: application/json" localhost:8545 | jq -r '.result.enode')
fi

if [ -z "$ENODE" ] || [[ "$ENODE" == "null" ]]; then
  echo "Error, check the atributtes of the bootnode(ADMIN tag, port TCP...) or if it is running."
  exit 1
fi

echo "ENODE found: $ENODE"

# Update configValidators.toml with the enode
echo "Updating configValidators.toml with the enode..."


CONFIG_FILE="configValidators.toml"
TMP_FILE=$(mktemp)

# Check if the file exists
if grep -q "^bootnodes" "$CONFIG_FILE"; then
  sed "s|^bootnodes=.*|bootnodes=[\"$ENODE\"]|" "$CONFIG_FILE" > "$TMP_FILE"
else
  echo "bootnodes=[\"$ENODE\"]" >> "$CONFIG_FILE"
  cp "$CONFIG_FILE" "$TMP_FILE"
fi

mv "$TMP_FILE" "$CONFIG_FILE"

echo "configValidators.toml updated bootnode:"
echo "  $ENODE"
