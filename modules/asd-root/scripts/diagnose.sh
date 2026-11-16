#!/system/bin/sh
uid="$(id -u 2>/dev/null)"
if [ "$uid" != 0 ]; then
  echo "ERROR: ASD-ROOT requires Shizuku Next started with its supported root method."
  echo "Current UID: ${uid:-unknown}. No privilege escalation will be attempted."
  exit 2
fi
section() { printf '\n===== %s =====\n' "$1"; }
prop() { getprop "$1" 2>/dev/null || echo unavailable; }
echo "Android System Diagnostic - ROOT profile"
echo "Timestamp: $(date 2>/dev/null || echo unavailable)"
echo "Execution UID: $uid"
section DEVICE
for key in ro.product.manufacturer ro.product.brand ro.product.model ro.product.device ro.build.version.release ro.build.version.sdk ro.build.display.id ro.build.fingerprint ro.product.cpu.abi ro.product.cpu.abilist; do echo "$key: $(prop "$key")"; done
echo "Kernel: $(uname -a 2>/dev/null || echo unavailable)"
section SECURITY
echo "SELinux: $(getenforce 2>/dev/null || echo unavailable)"
for key in ro.boot.verifiedbootstate ro.boot.flash.locked ro.boot.vbmeta.device_state ro.boot.veritymode; do echo "$key: $(prop "$key")"; done
section ROOT_ENVIRONMENT_DETECTION_ONLY
echo "PATH: $PATH"
for path in /system/bin/su /system/xbin/su /sbin/su /su/bin/su /debug_ramdisk/.magisk /data/adb; do [ -e "$path" ] && ls -ld "$path" 2>/dev/null; done
section PROCESS_VISIBILITY
ps -A 2>/dev/null | head -n 80
section BINDER_AND_FILESYSTEM
for path in /dev/binder /dev/vndbinder /dev/hwbinder /metadata; do [ -e "$path" ] && ls -ld "$path" 2>/dev/null; done
section LIMITATIONS
echo "Read-only snapshot; results depend on vendor policy and Android version."
echo "No system settings are changed. No application security checks are bypassed."
