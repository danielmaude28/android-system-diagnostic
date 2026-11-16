# Architecture and privilege model

ASD follows the Shizuku Next ADB module format. Scripts run with the Shizuku server's effective identity: normally shell for an ADB-started server, or UID 0 for a root-started server.

The module cannot elevate itself. ASD-ROOT checks UID 0 and exits safely otherwise. It never invokes su to obtain privileges.

Each ZIP contains module.prop and action.sh at archive root. The diagnostic script is under scripts/diagnose.sh. No background service is included; diagnostics are manually invoked.

All checks are read-only. No system, boot, SELinux, Verified Boot, root-hiding, integrity-spoofing, or banking-app security settings are modified. Reports may include device identifiers and build fingerprints; review before sharing.

Android vendor builds differ. Missing values can mean inaccessible or unavailable, not necessarily absent.
