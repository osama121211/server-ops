#!/usr/bin/env bash
# ops-agent runner
set -euo pipefail

# === إعدادات عامة ===
REPO_DIR="/root/server-ops"
STATE_DIR="/var/lib/ops-agent"
LOG="/var/log/ops-agent.log"
LAST_FILE="$STATE_DIR/last_commit"

mkdir -p "$(dirname "$LOG")" "$STATE_DIR"
cd "$REPO_DIR"

# === ربط الريبو وتحديثه ===
# أضف remote origin لو مش موجود
if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin git@github.com:osama121211/server-ops.git
fi

# جلب كل الفروع والمراجع (الصيغة الصحيحة بدون اسم ريبوتوري)
git fetch --all || true

# اختَر الفرع الصحيح (main أو master)
BRANCH="main"
if ! git show-ref --verify --quiet refs/remotes/origin/main; then
  BRANCH="master"
fi

# حدّث العمل المحلي لأحدث نقطة
git reset --hard "origin/${BRANCH}"

# === تحديد التغييرات ===
CURRENT="$(git rev-parse HEAD)"

# أول تشغيل؟ شغّل كل السكربتات الموجودة داخل scripts/
if [[ ! -f "$LAST_FILE" ]]; then
  CHANGED=$(git ls-files 'scripts/*.sh' || true)
else
  PREV="$(cat "$LAST_FILE")"
  # احصل على الملفات المتغيرة بين آخر تشغيل والحالي ومحصورة في scripts/*.sh
  CHANGED="$(git diff --name-only "$PREV" "$CURRENT" -- 'scripts/*.sh' || true)"
fi

# أعطِ صلاحية التنفيذ لكل سكربت .sh داخل مجلد scripts (مره واحدة كل تشغيل)
find scripts -type f -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true

# === تنفيذ السكربتات المتغيرة وتسجيل النتائج ===
EXIT=0
if [[ -n "${CHANGED:-}" ]]; then
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    echo "[$(date -Is)] RUN $f" | tee -a "$LOG"
    bash "$f" >>"$LOG" 2>&1 || EXIT=1
  done <<< "$CHANGED"
else
  echo "[$(date -Is)] No changed scripts to run." | tee -a "$LOG"
fi

# حدِّث آخر كومِت وتمّ
echo "$CURRENT" > "$LAST_FILE"
exit $EXIT
