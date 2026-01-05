import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_progress_circle/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const ProgressCircleDemo(),
    );
  }
}

class ProgressCircleDemo extends StatefulWidget {
  const ProgressCircleDemo({super.key});

  @override
  State<ProgressCircleDemo> createState() => _ProgressCircleDemoState();
}

class _ProgressCircleDemoState extends State<ProgressCircleDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Progress Circle Demo'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
// Inside your build method
          Center(
            child: SmartProgressCircle(
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
            ),
          ),
        ],
      ),
    );
  }
}
