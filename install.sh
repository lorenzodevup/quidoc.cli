#!/usr/bin/env bash
set -euo pipefail

REPO="https://raw.githubusercontent.com/lorenzodevup/quidoc.cli/master"
VERSION="v1.0.0"
PKG="quidoc"

echo 1

[[ $EUID -eq 0 ]] || { echo "Usa sudo"; exit 1; }

ARCH=$(dpkg --print-architecture)
case "$ARCH" in
  amd64|arm64) ;;
  *) echo "Architettura non supportata: $ARCH"; exit 1 ;;
esac

echo 2

TMP=$(mktemp -d)
cd "$TMP"

echo "📥 Scarico checksum e firma"
curl -fsSLO "$REPO/releases/$VERSION/SHA256SUMS"
curl -fsSLO "$REPO/releases/$VERSION/SHA256SUMS.sig"
curl -fsSLO "$REPO/quidoc.gpg"

echo 3

echo "🔐 Verifica firma"
gpg --import quidoc.gpg
gpg --verify SHA256SUMS.sig SHA256SUMS

DEB="${PKG}_1.0.0_${ARCH}.deb"

echo "📦 Scarico pacchetto"
curl -fsSLO "$REPO/releases/$VERSION/$DEB"

echo "🧪 Verifica checksum"
sha256sum -c SHA256SUMS --ignore-missing

echo "⚙️ Installazione"
dpkg -i "$DEB" || apt -f install -y

echo "✅ Installazione completata"

