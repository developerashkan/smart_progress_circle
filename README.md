# Circular Progress Bar Flutter Plugin

## Overview

A Modern, Interactive Circular Slider for Flutter

SmartProgressCircle is a highly customizable, animated circular slider widget for Flutter. It combines smooth gesture-driven interaction, modern gradient-based visuals, optional haptic feedback, and a polished bottom-sheet editor for precise value input.

This widget is designed for production use and fits naturally in dashboards, health and fitness apps, IoT controls, finance tools, and advanced settings panels.

---

## Features

- Drag-to-adjust circular slider
- Tap to open a bottom-sheet editor (slider + numeric input)
- Smooth animated transitions with easing curves
- Gradient progress arc using `SweepGradient`
- Animated knob with radial gradient and shadow
- Optional tick marks around the circle
- Percentage or numeric value display
- Optional haptic feedback
- Accessibility support via Flutter Semantics
- Theme-aware (light and dark mode friendly)
- Sensible defaults with deep customization options


![Screenshot 2024-10-23 173828](https://github.com/user-attachments/assets/341e69d5-2999-4402-8a56-d13541b76a1c)


## Installation

To use the Circular Progress Bar plugin in your Flutter project, follow these steps:

1. Add the dependency to your `pubspec.yaml` file:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     smart_progress_circle: ^0.0.6 # Replace with the latest version
   ```

2. Run the following command to install the package:

   ```bash
   flutter pub get
   ```

## Usage

To use the `CircularProgressBar` widget in your Flutter application, import the package and create an instance of the widget with your desired parameters.

### Example

```dart
SmartProgressCircle(
minValue: 0,
maxValue: 100,
initialValue: 25,
size: 300,
icon: const Icon(Icons.thermostat, size: 48, color: Colors.deepPurple),
label: 'Temperature',
gradientColors: const [
Color(0xFF00FFFF), // Electric Cyan
Color(0xFFBD00FF), // Neon Purple
Color(0xFFFF00FF), // Hot Pink
],
backgroundGradient: const [
Color(0xFFF8FAFC),
Color(0xFFE2E8F0),
],
ticks: 20,
showTicks: true,
strokeWidth: 24,
enableHaptics: true,
onChanged: (value) {
if (kDebugMode) {
print('New value: $value');
}
},
)
```

### Parameters

| Parameter               | Type                | Description                                                                                       |
|-------------------------|---------------------|---------------------------------------------------------------------------------------------------|
| `minValue`              | `double`            | The minimum value of the progress bar.                                                           |
| `maxValue`              | `double`            | The maximum value of the progress bar.                                                           |
| `initialValue`          | `double`            | The initial value displayed on the progress bar.                                                 |
| `icon`                  | `Widget`            | An icon widget displayed at the center of the progress bar.                                      |
| `calculationCriteria`   | `String`            | A string that describes what the progress bar represents.                                        |
| `size`                  | `double` (optional) | The size of the circular progress bar. Defaults to `250.0`.                                      |
| `backgroundColor`       | `Color` (optional)  | The background color of the progress bar. Defaults to light or dark theme color.                 |
| `progressColor`         | `Color` (optional)  | The color of the progress arc. Defaults to a gradient of red.                                    |
| `markColor`             | `Color` (optional)  | The color of the marks around the progress bar. Defaults to light grey.                          |
| `borderColor`           | `Color` (optional)  | The color of the border of the progress bar. Defaults to light or dark theme color.              |
| `dialogBackgroundColor` | `Color` (optional)  | The background color of the input dialog. Defaults to the scaffold background color.              |
| `dialogTextColor`       | `Color` (optional)  | The text color in the input dialog. Defaults to black.                                           |
| `buttonColor`           | `Color` (optional)  | The color of the OK button in the dialog. Defaults to red.                                       |
| `buttonTextColor`       | `Color` (optional)  | The text color of the OK button. Defaults to white.                                             |
| `cancelButtonColor`     | `Color` (optional)  | The color of the Cancel button in the dialog. Defaults to white.                                 |
| `cancelButtonTextColor` | `Color` (optional)  | The text color of the Cancel button. Defaults to red.                                           |
| `onChanged`             | `void Function(double)?` (optional)  | This is a callback function that allows users to define custom behavior that should occur when the value changes.                                           |


## Customization

You can customize the `CircularProgressBar` by providing your own colors and sizes. If any parameter is not provided, the widget will use its default values.

## Contribution

If you would like to contribute to this plugin, please feel free to submit a pull request or open an issue on the repository. Contributions, suggestions, and feedback are always welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Support

For any questions or support, please open an issue in the repository or contact the author.

---

This README provides a comprehensive overview of the Circular Progress Bar Flutter Plugin, including installation instructions, usage examples, and customization options. Adjust the version number and import paths as necessary for your project structure.
