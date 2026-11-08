# Changelog

## 2.0.0 — Smart Scan & HTTP 403 Diagnostics

- Added explicit BLOCKED and RATE LIMITED classifications.
- Reduced default scan wave size to 5 sites, with 5-second inter-wave cooldown and 15-second inter-username cooldown.
- Added automatic pause when at least 60% of a wave is denied or rate-limited.
- Added neutral-endpoint connectivity diagnostics and proxy environment summary.
- Added local per-platform reliability history.
- Added v1 settings migration to conservative defaults while preserving theme, timeout, batch size, and database history.
- Added tests for HTTP status classification, scan batching, database migration, and configuration migration.

## 1.0.0

- Initial Windows desktop application.
