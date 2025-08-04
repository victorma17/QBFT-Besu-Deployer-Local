#!/bin/bash

# Paso 1: Esperar a que el nodo arranque y abra el puerto RPC
echo "⏳ Esperando a que el bootnode responda en http://localhost:8545 ..."
# until curl -s http://localhost:8545 >/dev/null; do sleep 1; done
# until curl -s http://127.0.0.1:30303 >/dev/null; do sleep 1; done

# Paso 2: Obtener enode del bootnode vía RPC
echo "📡 Obteniendo enode desde el bootnode..."
ENODE=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H "Content-Type: application/json" localhost:8545 | jq -r '.result[0].enode')
if [ -z "$ENODE" ] || [[ "$ENODE" == "null" ]]; then
  ENODE=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H "Content-Type: application/json" localhost:8545 | jq -r '.result.enode')
fi

if [ -z "$ENODE" ] || [[ "$ENODE" == "null" ]]; then
  echo "❌ No se pudo obtener el enode."
  exit 1
fi

echo "✅ ENODE encontrado: $ENODE"

# Paso 3: Reemplazar/encontrar línea en el .toml
echo "✏️ Actualizando configValidators.toml..."

CONFIG_FILE="configValidators.toml"
TMP_FILE=$(mktemp)

# Si ya existe una línea bootnodes=..., la reemplaza
if grep -q "^bootnodes" "$CONFIG_FILE"; then
  sed "s|^bootnodes=.*|bootnodes=[\"$ENODE\"]|" "$CONFIG_FILE" > "$TMP_FILE"
else
  echo "bootnodes=[\"$ENODE\"]" >> "$CONFIG_FILE"
  cp "$CONFIG_FILE" "$TMP_FILE"
fi

mv "$TMP_FILE" "$CONFIG_FILE"

echo "✅ configValidators.toml actualizado con bootnode:"
echo "  $ENODE"
