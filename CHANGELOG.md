# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-02-23

### Fixed
- PDF formatting with proper bullet point rendering
- Equal left and right margins (10mm both sides)
- Improved spacing with minimal header padding
- Better text wrapping respecting both margins

### Added
- Bullet point formatting with • bullets and 5mm indent
- Increased line height to 4.5mm for better readability

## [0.1.0] - 2026-02-23

### Added
- Initial project setup with TypeScript scripts pattern
- PDF generation from markdown using jsPDF + marked
- Resume tailoring command (@local.tailor)
- ACP integration with commands, design docs, patterns
- TypeScript scripts in scripts/ directory with isolated dependencies
