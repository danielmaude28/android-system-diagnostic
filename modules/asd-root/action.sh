#!/system/bin/sh
MODDIR="${MODDIR:-$(CDPATH= cd -- "$(dirname -- "$0")" 2>/dev/null && pwd)}"
[ -f "$MODDIR/scripts/diagnose.sh" ] || { echo "ASD-ROOT: diagnostic script not found"; exit 1; }
exec sh "$MODDIR/scripts/diagnose.sh" root
