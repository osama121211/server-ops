#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/root/server-ops"
LOG="/var/log/ops-agent.log"

mkdir -p "$(dirname "$LOG")"

cd "$REPO_DIR"

# تأكد أن الريموت مضبوط
if ! git remote get-url origin >/dev/null 2>&1; then
  git remote add origin git@github.com:osama121211/server-ops.git
fi

# اسحب آخر نسخة وحدّد الفرع المتاح (main أو master)
git fetch origin --all || true
BRANCH="main"
if ! git show-ref --verify --quiet refs/remotes/origin/main; then
  BRANCH="master"
fi
git reset --hard "origin/$BRANCH"

LAST_FILE=".last_commit"
CURRENT="$(git rev-parse HEAD)"

# اعرف ما هي السكربتات المتغيرة داخل مجلد scripts
if [[ ! -f "$LAST_FILE" ]]; then
  CHANGED="$(git ls-files 'scripts/*.sh' || true)"
else
  CHANGED="$(git diff --name-only "$(cat "$LAST_FILE")" "$CURRENT" -- 'scripts/*.sh' || true)"
fi

# اجعل كل سكربتات الشِل قابلة للتنفيذ
find scripts -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# شغّل السكربتات المتغيرة بالترتيب
EXIT=0
for f in $CHANGED; do
  echo "[$(date -Is)] RUN $f" | tee -a "$LOG"
  bash "$f" >>"$LOG" 2>&1 || EXIT=1
done

echo "$CURRENT" > "$LAST_FILE"
exit $EXIT
