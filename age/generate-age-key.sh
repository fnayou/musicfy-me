#!/usr/bin/env bash
# Generate the age keypair in age/ and seed secrets/.sops.yaml.
# The private key (age/key.txt) is gitignored and must never be committed.
# Back it up somewhere safe: without it the encrypted secrets cannot be read.
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEY_FILE="${PROJECT_DIR}/age/key.txt"
SOPS_CONFIG="${PROJECT_DIR}/secrets/.sops.yaml"

if [ -f "$KEY_FILE" ]; then
  echo "age key already exists at ${KEY_FILE}; nothing to do."
  exit 0
fi

# The container runs as root to install age, then hands the key to the caller.
docker run --rm -v "${PROJECT_DIR}/age:/age" alpine:3.22 sh -c \
  "apk add --no-cache age >/dev/null && age-keygen -o /age/key.txt 2>/dev/null && chown $(id -u):$(id -g) /age/key.txt"
chmod 600 "$KEY_FILE"

PUBLIC_KEY="$(grep '^# public key: ' "$KEY_FILE" | cut -d ' ' -f 4)"
if [ -z "$PUBLIC_KEY" ]; then
  echo "Error: could not read the public key from ${KEY_FILE}" >&2
  exit 1
fi
echo "age public key: ${PUBLIC_KEY}"

if [ ! -f "$SOPS_CONFIG" ]; then
  mkdir -p "$(dirname "$SOPS_CONFIG")"
  cat > "$SOPS_CONFIG" <<EOF
creation_rules:
  # Matches the plaintext input and the encrypted output of secrets/.
  - path_regex: '(^|/)secrets(\.sops)?\.ya?ml$'
    age: ${PUBLIC_KEY}
EOF
  echo "Created ${SOPS_CONFIG}."
else
  echo "${SOPS_CONFIG} exists; add the public key above to it by hand if it is missing."
fi
