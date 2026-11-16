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

The two ZIPs are separate module identities and policy profiles, not privilege-escalation mechanisms. ASD-ROOT checks that it is actually UID 0 and exits safely otherwise. No script attempts to gain root.

## Current scope
- Device/build/ABI/kernel information
- SELinux and Verified Boot property observations
- Root indicator and KernelSU CLI observations (detection only)
- Shizuku process and Binder observations
- Timestamped plain-text report export
- Root auto-start and persistence observations, with unknown states kept explicitly unknown

## Report export
Each run attempts to save a timestamped report under:
`/sdcard/Download/ASD-Reports/`

If shared storage is unavailable, the script tries:
`/storage/emulated/0/Download/ASD-Reports/` then `/data/local/tmp/ASD-Reports/`.

The report is also printed to the module output. If all file destinations are unavailable, console output remains available. Reports may contain device identifiers and build fingerprints; review before sharing.

## Root environment and persistence
ASD-ROOT verifies UID 0 and reports the SELinux context, KernelSU CLI version when accessible, and relevant filesystem observations. ASD-ADB reports only what its shell identity can see.

Generic shell diagnostics cannot reliably read the ReSuKiSu UI selections for LKM/Jailbreak or prove auto-start configuration. The initial Infinix X6531B test-device baseline is user-confirmed: ReSuKiSu shows LKM and Jailbreak active, Start on boot and automatic Jailbreak enabled, and root becomes active after reboot without manually launching DirtyFrag. This is recorded as a user-reported test observation, not an automatic verdict produced by ASD.

## Safety
All checks are read-only. No boot, system, SELinux, Verified Boot, root-hiding, integrity-spoofing, or banking-app security settings are modified. Diagnostic indicators are observations, not a guarantee that a device passes any app's security policy.

## Build
GitHub Actions builds `ASD-ADB.zip`, `ASD-ROOT.zip`, and SHA-256 checksums. Download ZIPs from the successful Actions run's artifacts and install through Shizuku Next's Modules screen.

## Compatibility
The package follows Shizuku Next's documented module format: root-level `module.prop`, `action.sh`, and module-local scripts. WebUI and background services are intentionally omitted.
