#!/system/bin/sh
MODE="${1:-adb}"
section() { printf '\n===== %s =====\n' "$1"; }
prop() { getprop "$1" 2>/dev/null || echo unavailable; }
uid="$(id -u 2>/dev/null)"
echo "Android System Diagnostic - ADB profile"
echo "Timestamp: $(date 2>/dev/null || echo unavailable)"
echo "Execution UID: ${uid:-unknown}"
[ "$uid" = 0 ] && echo "NOTICE: running as UID 0; actual Shizuku server identity differs from expected ADB shell."
section DEVICE
for key in ro.product.manufacturer ro.product.brand ro.product.model ro.product.device ro.build.version.release ro.build.version.sdk ro.build.display.id ro.build.fingerprint ro.product.cpu.abi ro.product.cpu.abilist; do echo "$key: $(prop "$key")"; done
echo "Kernel: $(uname -a 2>/dev/null || echo unavailable)"
section SECURITY
echo "SELinux: $(getenforce 2>/dev/null || echo unavailable)"
for key in ro.boot.verifiedbootstate ro.boot.flash.locked ro.boot.vbmeta.device_state ro.boot.veritymode; do echo "$key: $(prop "$key")"; done
section ROOT_INDICATORS_DETECTION_ONLY
for path in /system/bin/su /system/xbin/su /sbin/su /su/bin/su; do [ -e "$path" ] && echo "Present: $path"; done
command -v su 2>/dev/null || echo "su command not found in PATH"
section SERVICES_AND_BINDER
ps -A 2>/dev/null | grep -i '[s]hizuku' || echo "No Shizuku process visible"
for path in /dev/binder /dev/vndbinder /dev/hwbinder; do [ -e "$path" ] && echo "Present: $path"; done
section LIMITATIONS
echo "Read-only snapshot; inaccessible or blank values do not prove absence."
echo "No integrity verdict is calculated. No app-security checks are bypassed or altered."
