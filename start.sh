#!/bin/sh
set -e

echo "--- PocketBase Versiyon Kontrolü ---"
/usr/local/bin/pocketbase --version || echo "Versiyon okunamadı"
echo ""

echo "# 1. KONTROL: DATABASE_URL var mı ve geçerli mi?"
if [ -z "${DATABASE_URL}" ] || ! echo "${DATABASE_URL}" | grep -q "postgres"; then
  echo "!!! HATA: DATABASE_URL eksik veya geçersiz."
  exit 1
fi

echo "# 2. KONTROL: POCKETBASE_ENCRYPTION var mı?"
if [ -z "${POCKETBASE_ENCRYPTION}" ]; then
  echo "!!! HATA: POCKETBASE_ENCRYPTION eksik."
  exit 1
fi

echo "Tüm kontroller tamam. PocketBase PostgreSQL ile başlatılıyor..."
/usr/local/bin/pocketbase serve --http="0.0.0.0:8080" --db="${DATABASE_URL}" --encryptionEnv="POCKETBASE_ENCRYPTION"
