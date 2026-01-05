# Changelog

## [0.0.6]
### Fixed
- **Gradient Mapping:** Resolved an issue where the final colors (e.g., orange/red) would appear at the 0% mark. The gradient now dynamically scales its stops to match the current progress.
- **Start Angle:** Fixed the rotation offset to ensure the progress consistently begins at the 12 o'clock position across all devices.

### Added
- **Visual Gap:** Introduced a 5% transparency gap at the start of the progress track for a cleaner, more modern aesthetic.
- **Dynamic Stops:** Gradient colors now "squish" and "stretch" as the slider moves, ensuring the knob always sits on the final color defined in the list.

### Changed
- **Package Identity:** Renamed the project and updated all internal library references to `modern_progress_circle`.
- **Default Styling:** Updated default `gradientColors` to a softer, more premium palette.
- 
## [0.0.5]
- Update CopyRight



