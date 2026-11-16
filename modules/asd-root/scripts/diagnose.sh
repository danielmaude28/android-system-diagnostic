#!/system/bin/sh
uid="$(id -u 2>/dev/null)"
if [ "$uid" != 0 ]; then
  echo "ERROR: ASD-ROOT requires Shizuku Next started with its supported root method."
  echo "Current UID: ${uid:-unknown}. No privilege escalation will be attempted."
  exit 2
fi
section() { printf '\n===== %s =====\n' "$1"; }
prop() { getprop "$1" 2>/dev/null || echo unavailable; }

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
  REPORT_FILE="$REPORT_DIR/ASD-ROOT-$STAMP-$$.txt"
  if ! (umask 077; : > "$REPORT_FILE") 2>/dev/null; then REPORT_FILE=""; fi
fi
if [ -n "$REPORT_FILE" ]; then
  exec 3>&1 4>&2
  exec > "$REPORT_FILE" 2>&1
fi

echo "Android System Diagnostic - ROOT profile"
echo "Timestamp: $(date 2>/dev/null || echo unavailable)"
echo "Execution UID: $uid"
echo "SELinux context: $(id -Z 2>/dev/null || echo unavailable)"

section DEVICE
for key in ro.product.manufacturer ro.product.brand ro.product.model ro.product.device ro.build.version.release ro.build.version.sdk ro.build.display.id ro.build.fingerprint ro.product.cpu.abi ro.product.cpu.abilist; do echo "$key: $(prop "$key")"; done
echo "Kernel: $(uname -a 2>/dev/null || echo unavailable)"

section SECURITY
echo "SELinux: $(getenforce 2>/dev/null || echo unavailable)"
for key in ro.boot.verifiedbootstate ro.boot.flash.locked ro.boot.vbmeta.device_state ro.boot.veritymode; do echo "$key: $(prop "$key")"; done

section ROOT_ENVIRONMENT_AND_PERSISTENCE
echo "PATH: $PATH"
for path in /system/bin/su /system/xbin/su /sbin/su /su/bin/su /data/adb /data/adb/ksu /data/adb/ksud; do
  if [ -e "$path" ]; then ls -ld "$path" 2>/dev/null || echo "Present: $path"; fi
done
if command -v ksud >/dev/null 2>&1; then ksud --version 2>&1; elif [ -x /data/adb/ksud ]; then /data/adb/ksud --version 2>&1; else echo "KernelSU CLI: not detected"; fi
echo "LKM mode / Jailbreak mode: not reliably readable by this generic diagnostic; confirm in ReSuKiSu UI."
echo "Auto-start after reboot: user-confirmed on the project test device; not independently verified during this run."
echo "Root persistence mechanism: not inferred from UID 0 or KernelSU file presence alone."

section PROCESS_VISIBILITY
ps -A 2>/dev/null | head -n 100

section BINDER_AND_FILESYSTEM
for path in /dev/binder /dev/vndbinder /dev/hwbinder /metadata; do [ -e "$path" ] && ls -ld "$path" 2>/dev/null; done

section LIMITATIONS
echo "Read-only snapshot; results depend on vendor policy and Android version."
echo "No system settings are changed. No application security checks are bypassed."
if [ -n "$REPORT_FILE" ]; then echo "Report output: $REPORT_FILE"; else echo "Report output: file export unavailable; showing console output only."; fi

if [ -n "$REPORT_FILE" ]; then
  exec 1>&3 2>&4
  cat "$REPORT_FILE"
  echo "Saved report: $REPORT_FILE"
fi
