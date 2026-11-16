#!/system/bin/sh
MODE="${1:-adb}"
section() { printf '\n===== %s =====\n' "$1"; }
prop() { getprop "$1" 2>/dev/null || echo unavailable; }

# Save a timestamped, user-accessible report when possible.
REPORT_DIR=""
for candidate in /sdcard/Download/ASD-Reports /storage/emulated/0/Download/ASD-Reports /data/local/tmp/ASD-Reports; do
  if mkdir -p "$candidate" 2>/dev/null && [ -w "$candidate" ]; then
    REPORT_DIR="$candidate"
    break
  fi
done
STAMP="$(date '+%Y%m%d-%H%M%S' 2>/dev/null)"
[ -n "$STAMP" ] || STAMP="unknown-time"
REPORT_FILE=""
if [ -n "$REPORT_DIR" ]; then
  REPORT_FILE="$REPORT_DIR/ASD-ADB-$STAMP-$$.txt"
  if ! (umask 077; : > "$REPORT_FILE") 2>/dev/null; then REPORT_FILE=""; fi
fi
if [ -n "$REPORT_FILE" ]; then
  exec 3>&1 4>&2
  exec > "$REPORT_FILE" 2>&1
fi

uid="$(id -u 2>/dev/null)"
echo "Android System Diagnostic - ADB profile"
echo "Timestamp: $(date 2>/dev/null || echo unavailable)"
echo "Execution UID: ${uid:-unknown}"
[ "$uid" = 0 ] && echo "NOTICE: running as UID 0; this is not the usual ADB shell identity."

section DEVICE
for key in ro.product.manufacturer ro.product.brand ro.product.model ro.product.device ro.build.version.release ro.build.version.sdk ro.build.display.id ro.build.fingerprint ro.product.cpu.abi ro.product.cpu.abilist; do echo "$key: $(prop "$key")"; done
echo "Kernel: $(uname -a 2>/dev/null || echo unavailable)"

section SECURITY
echo "SELinux: $(getenforce 2>/dev/null || echo unavailable)"
for key in ro.boot.verifiedbootstate ro.boot.flash.locked ro.boot.vbmeta.device_state ro.boot.veritymode; do echo "$key: $(prop "$key")"; done

section ROOT_ENVIRONMENT_DETECTION_ONLY
for path in /system/bin/su /system/xbin/su /sbin/su /su/bin/su /data/adb/ksu /data/adb/ksud; do
  if [ -e "$path" ]; then ls -ld "$path" 2>/dev/null || echo "Present but metadata inaccessible: $path"; fi
done
if command -v ksud >/dev/null 2>&1; then ksud --version 2>&1; else echo "ksud in PATH: not detected"; fi
if [ -x /data/adb/ksud ]; then /data/adb/ksud --version 2>&1; else echo "KernelSU CLI at /data/adb/ksud: not accessible or absent"; fi
echo "LKM mode / Jailbreak mode: not reliably readable by this generic diagnostic."
echo "Auto-start after reboot: cannot be inferred from a single live snapshot."
echo "Project test-device note: user reported root becomes active automatically after reboot; this is a user-confirmed observation, not a live script verification."

section SERVICES_AND_BINDER
ps -A 2>/dev/null | grep -i '[s]hizuku' || echo "No Shizuku process visible"
for path in /dev/binder /dev/vndbinder /dev/hwbinder; do [ -e "$path" ] && echo "Present: $path"; done

section LIMITATIONS
echo "Read-only snapshot; inaccessible or blank values do not prove absence."
echo "No integrity verdict is calculated. No app-security checks are bypassed or altered."
if [ -n "$REPORT_FILE" ]; then echo "Report output: $REPORT_FILE"; else echo "Report output: file export unavailable; showing console output only."; fi

if [ -n "$REPORT_FILE" ]; then
  exec 1>&3 2>&4
  cat "$REPORT_FILE"
  echo "Saved report: $REPORT_FILE"
fi
