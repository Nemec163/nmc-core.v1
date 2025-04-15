#!/bin/bash

echo "🔄 Перезапуск Nginx..."
nginx -t && systemctl reload nginx
echo "✅ Nginx перезагружен"
