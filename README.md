# Android System Diagnostic (ASD)

Read-only Android diagnostics delivered as Shizuku Next ADB modules.

## Initial targets
- Android 14 / API 34
- Infinix X6531B (initial test device)
- Two separately packaged variants: **ASD-ADB** and **ASD-ROOT**

## Important architecture note
Shizuku Next implements the Nightzuku/Shevery ADB module format. A module does not select or elevate its own privilege. Its commands run with the identity of the Shizuku server:
- ADB-started server: normally Android `shell` identity.
- Root-started server: root identity, when the app's supported root start method is used.

The two ZIPs are therefore separate module identities and policy profiles, not privilege-escalation mechanisms. ASD-ROOT checks that it is actually UID 0 and exits safely otherwise. No script attempts to gain root.

## Current scope (v0.1.0)
- Device/build/ABI/kernel information
- SELinux and Verified Boot property observations
- Root indicator inventory (detection only; no hiding or bypass)
- Shizuku execution identity and basic service observations
- Plain-text diagnostic report

All checks are read-only. No boot, system, security, banking-app, or integrity settings are modified. Diagnostic indicators are observations, not a guarantee that a device passes any app's security policy.

## Build
GitHub Actions builds:
- `ASD-ADB.zip`
- `ASD-ROOT.zip`
- SHA-256 checksums

Download ZIPs from the successful Actions run's artifacts. Install through Shizuku Next's Modules screen using the ZIP picker. Do not mark the module trusted until you have reviewed its scripts.

## Compatibility
The package follows Shizuku Next's documented module format: root-level `module.prop`, `action.sh`, and module-local scripts. WebUI and background services are intentionally omitted in this first release.

## Safety
The module never changes system state. It does not hide root, alter Play Integrity, interfere with banking-app checks, disable SELinux, or modify Verified Boot. Use the report for troubleshooting and legitimate device maintenance.

## Project status
Initial scaffold; CI validation is the first milestone. Physical testing on the target phone is still required.
