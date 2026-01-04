#!/usr/bin/env bash
set -e

REPO="https://raw.githubusercontent.com/lorenzodevup/quidoc.cli/master"
VERSION="v1.0.0"
DEB="quidoc1.0_amd64.deb"
KEYRING="/usr/share/keyrings/quidoc.gpg"

echo "Installo chiave GPG"
curl -fsSL "$REPO/quidoc.gpg" | gpg --dearmor -o "$KEYRING"

echo "Scarico checksum e firma"
curl -fsSLO "$REPO/releases/$VERSION/SHA256SUMS"
curl -fsSLO "$REPO/releases/$VERSION/SHA256SUMS.sig"

echo "Verifico firma"
if gpg --no-default-keyring \
       --keyring "$KEYRING" \
       --verify SHA256SUMS.sig SHA256SUMS \
       2>/dev/null; then
  echo "Firma verificata"
else
  echo "Firma non valida"
  exit 1
fi

echo "Scarico pacchetto"
echo "$REPO"
echo "$VERSION"
echo "$DEB"
echo "$REPO/releases/$VERSION/$DEB"
curl -fsSLO "$REPO/releases/$VERSION/$DEB"

echo "Verifico checksum"
sha256sum -c SHA256SUMS --ignore-missing

echo "Installo"
dpkg -i "$DEB"
exit 0
