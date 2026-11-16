# Changelog

## 0.2.0 - Report export and root environment observations
- Export timestamped TXT reports to shared Download storage when writable, with safe fallback locations.
- Keep console output available and print the final report path.
- Add KernelSU CLI and root-environment observations.
- Explicitly distinguish user-confirmed reboot behavior from automatic runtime detection.
- Document that generic diagnostics cannot reliably inspect ReSuKiSu UI mode selections.
- Preserve read-only behavior and UID 0 verification in ASD-ROOT.

## 0.1.0 - Initial scaffold
- Add separate Shizuku Next ADB and ROOT diagnostic modules.
- Add read-only device, security-property, root-indicator, process and Binder observations.
- ROOT profile verifies UID 0 and never attempts privilege escalation.
- Add GitHub Actions packaging, shell syntax validation, archive layout validation and SHA-256 checksums.
