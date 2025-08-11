#!/usr/bin/env bash
# ===== إعداد متغيرات البيئة للموقع =====

# اسم الدومين (اكتب دومينك إن وُجد، أو اترك IP مؤقتًا)
export DOMAIN="148.230.108.230"   # غيّرها لاحقًا إلى yourdomain.com

# قاعدة البيانات
export DB_NAME="wp_prod"
export DB_USER="wp_user"
export DB_PASS="StrongPassword_ChangeMe123"   # غيّرها الآن

# مستخدم مدير ووردبريس
export WP_ADMIN_USER="admin"
export WP_ADMIN_PASS="ChangeMe!987"           # غيّرها الآن
export WP_ADMIN_EMAIL="you@example.com"

# مسارات وخيارات
export WEBROOT="/var/www/${DOMAIN}"
export PHP_VERSION="8.3"   # Ubuntu 24.04 فيها PHP 8.3

# SSL تلقائي لاحقًا عبر certbot (نفعّله بعد ما تربط الدومين DNS)
export ENABLE_SSL="no"
