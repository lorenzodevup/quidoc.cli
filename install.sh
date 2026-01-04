#!/usr/bin/env bash
set -e

REPO="https://raw.githubusercontent.com/lorenzodevup/quidoc.cli/master"
VERSION="v1.0.0"
DEB="quidoc1.0_amd64.deb"
KEYRING="/usr/share/keyrings/quidoc.gpg"

echo "🔑 Installo chiave GPG"
curl -fsSL "$REPO/quidoc.gpg" | gpg --dearmor -o "$KEYRING"

echo "📥 Scarico checksum e firma"
curl -fsSLO "$REPO/releases/$VERSION/SHA256SUMS"
curl -fsSLO "$REPO/releases/$VERSION/SHA256SUMS.sig"

echo "🔐 Verifico firma"
gpg --no-default-keyring \
    --keyring "$KEYRING" \
    --verify SHA256SUMS.sig SHA256SUMS

echo "📥 Scarico pacchetto"
echo "$REPO/releases/$VERSION/$DEB"
curl -fsSLO "$REPO/releases/$VERSION/$DEB"

echo "🔍 Verifico checksum"
sha256sum -c SHA256SUMS --ignore-missing

echo "📦 Installo"
dpkg -i "$DEB"
