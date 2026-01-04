#!/usr/bin/env bash
set -e

REPO="https://raw.githubusercontent.com/lorenzodevup/quidoc.cli/master"
VERSION="v1.0.0"
DEB="quidoc_1.0.0_amd64.deb"

echo "🔑 Importo chiave GPG"
sudo curl -fsSL "$REPO/quidoc.gpg" | gpg --dearmor -o /usr/share/keyrings/quidoc.gpg

echo "📥 Scarico checksum e firma"
curl -fsSLO "$REPO/releases/$VERSION/SHA256SUMS"
curl -fsSLO "$REPO/releases/$VERSION/SHA256SUMS.sig"

echo "🔐 Verifico firma"
gpg --verify SHA256SUMS.sig SHA256SUMS

echo "📥 Scarico pacchetto"
curl -fsSLO "$REPO/releases/$VERSION/$DEB"

echo "🔍 Verifico checksum"
sha256sum -c SHA256SUMS --ignore-missing

echo "📦 Installo"
dpkg -i "$DEB"

