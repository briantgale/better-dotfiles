#!/bin/sh

SSL_VERSION=`openssl version`

echo "[SwapSSL] Swapping openssl versions..."
if [[ $SSL_VERSION == 'OpenSSL 3'* ]]; then
  echo "[SwapSSL] Unlinking 3, linking 1.1"
  brew unlink openssl@3
  brew link openssl@1.1
else
  echo "[SwapSSL] Unlinking 1.1, linking 3"
  brew unlink openssl@1.1
  brew link openssl@3
fi
