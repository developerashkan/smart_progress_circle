import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Modern Circular Slider with gradient animations and smooth interactions
class SmartProgressCircle extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double initialValue;
  final Widget? icon;
  final String? label;
  final double size;

  // Visual customizations
  final double strokeWidth;
  final List<Color> gradientColors;
  final List<Color>? backgroundGradient;
  final List<Color>? knobGradient;
  final Color tickColor;
  final int ticks;
  final Color borderColor;
  final double borderWidth;
  final double knobSize;
  final bool showPercentage;
  final bool showTicks;
  final bool enableHaptics;
  final bool enableAnimation;

  // Dialog/Sheet styling
  final Color? sheetBackgroundColor;
  final Color? primaryColor;
  final Color? onPrimaryColor;

  // Callbacks
  final void Function(double)? onChanged;
  final String? semanticLabel;

  const SmartProgressCircle({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    this.icon,
    this.label,
    this.size = 280,
    this.strokeWidth = 22,
    this.gradientColors = const [
      Color(0x406366F1), // ~25% opacity
      Color(0x408B5CF6),
      Color(0x40EC4899),
    ],
    this.backgroundGradient,
    this.knobGradient,
    this.tickColor = const Color(0x18000000),
    this.ticks = 12,
    this.borderColor = const Color(0x0A000000),
    this.borderWidth = 2,
    this.knobSize = 16,
    this.showPercentage = false,
    this.showTicks = true,
    this.enableHaptics = true,
    this.enableAnimation = true,
    this.sheetBackgroundColor,
    this.primaryColor,
    this.onPrimaryColor,
    this.onChanged,
    this.semanticLabel,
  })  : assert(minValue < maxValue),
        super(key: key);

  @override
  State<SmartProgressCircle> createState() => _SmartProgressCircleState();
}

class _SmartProgressCircleState extends State<SmartProgressCircle>
    with SingleTickerProviderStateMixin {
  late double _value;
  late AnimationController _animController;
  late Animation<double> _valueAnimation;
  double _animatedValue = 0.0;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue.clamp(widget.minValue, widget.maxValue);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _valueAnimation = Tween<double>(begin: _value, end: _value).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    )..addListener(() {
        setState(() => _animatedValue = _valueAnimation.value);
      });

    _animatedValue = _value;
  }

  @override
  void didUpdateWidget(covariant SmartProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newVal = _value.clamp(widget.minValue, widget.maxValue);
    if (newVal != _value) _animateTo(newVal);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _animateTo(double newValue) {
    if (!widget.enableAnimation) {
      setState(() {
        _animatedValue = newValue;
        _value = newValue;
      });
      if (widget.onChanged != null) widget.onChanged!(_value);
      return;
    }

    _animController.stop();
    _valueAnimation = Tween<double>(
      begin: _animatedValue,
      end: newValue,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward(from: 0);
    _value = newValue;
    if (widget.onChanged != null) widget.onChanged!(_value);
  }

  double get _percentage =>
      (_animatedValue - widget.minValue) / (widget.maxValue - widget.minValue);

  void _updateFromLocalPosition(Offset localPos, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;

    double angle = atan2(dy, dx);
    double angleFromTop = angle + pi / 2;
    if (angleFromTop < 0) angleFromTop += 2 * pi;

    double progress = angleFromTop / (2 * pi);
    final newValue =
        (widget.minValue + progress * (widget.maxValue - widget.minValue))
            .clamp(widget.minValue, widget.maxValue);

    if ((newValue - _value).abs() > 0.01) {
      _animateTo(newValue);
      if (widget.enableHaptics) HapticFeedback.selectionClick();
    }
  }

  Future<void> _showEditSheet() async {
    final controller = TextEditingController(text: _value.toStringAsFixed(1));
    double tmpValue = _value;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color:
                    widget.sheetBackgroundColor ?? Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                left: 24,
                right: 24,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 48,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Title
                  Text(
                    widget.label ?? 'Set Value',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Slider with gradient track
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 14,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 28,
                      ),
                      activeTrackColor:
                          widget.primaryColor ?? widget.gradientColors.first,
                      inactiveTrackColor:
                          (widget.primaryColor ?? widget.gradientColors.first)
                              .withOpacity(0.2),
                      thumbColor: Colors.white,
                      overlayColor:
                          (widget.primaryColor ?? widget.gradientColors.first)
                              .withOpacity(0.2),
                    ),
                    child: Slider(
                      min: widget.minValue,
                      max: widget.maxValue,
                      value: tmpValue,
                      onChanged: (v) {
                        setModalState(() {
                          tmpValue = v;
                          controller.text = tmpValue.toStringAsFixed(1);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Text field
                  TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[100],
                    ),
                    onChanged: (txt) {
                      final parsed = double.tryParse(txt);
                      if (parsed != null) {
                        setModalState(() {
                          tmpValue = parsed.clamp(
                            widget.minValue,
                            widget.maxValue,
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Apply button with gradient
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: widget.gradientColors.first.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _animateTo(tmpValue.clamp(
                            widget.minValue,
                            widget.maxValue,
                          ));
                          Navigator.of(ctx).pop();
                        },
                        child: Center(
                          child: Text(
                            'Apply',
                            style: TextStyle(
                              color: widget.onPrimaryColor ?? Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Cancel button
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? 'Circular slider',
      value: '${_animatedValue.toStringAsFixed(1)}',
      child: GestureDetector(
        onPanDown: (details) {
          final box = context.findRenderObject() as RenderBox;
          _updateFromLocalPosition(
            box.globalToLocal(details.globalPosition),
            Size(widget.size, widget.size),
          );
        },
        onPanUpdate: (details) {
          final box = context.findRenderObject() as RenderBox;
          _updateFromLocalPosition(
            box.globalToLocal(details.globalPosition),
            Size(widget.size, widget.size),
          );
        },
        onTap: () async {
          // Allow current animations to visibly finish before showing confirmation sheet
          if (widget.enableAnimation && mounted) {
            final animDur =
                _animController.duration ?? const Duration(milliseconds: 600);
            await Future.delayed(animDur + const Duration(milliseconds: 220));
          }
          if (mounted) await _showEditSheet();
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            gradient: widget.backgroundGradient != null
                ? LinearGradient(colors: widget.backgroundGradient!)
                : null,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 12,
                offset: const Offset(-8, -8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ModernCirclePainter(
                  percentage: _percentage.clamp(0.0, 1.0),
                  strokeWidth: widget.strokeWidth,
                  gradientColors: widget.gradientColors,
                  borderColor: widget.borderColor,
                  borderWidth: widget.borderWidth,
                  tickColor: widget.tickColor,
                  ticks: widget.ticks,
                  showTicks: widget.showTicks,
                  knobSize: widget.knobSize,
                  knobGradient: widget.knobGradient ??
                      [Colors.white, Colors.grey.shade100],
                ),
              ),

              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(height: 8),
                  ],

                  // Animated value display
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: _animatedValue, end: _animatedValue),
                    duration: const Duration(milliseconds: 300),
                    builder: (_, val, __) {
                      return ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: widget.gradientColors,
                        ).createShader(bounds),
                        child: Text(
                          widget.showPercentage
                              ? '${(val / widget.maxValue * 100).toStringAsFixed(0)}%'
                              : val.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: widget.size * 0.14,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),

                  if (widget.label != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.label!,
                      style: TextStyle(
                        fontSize: widget.size * 0.065,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernCirclePainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color borderColor;
  final double borderWidth;
  final Color tickColor;
  final int ticks;
  final bool showTicks;
  final double knobSize;
  final List<Color> knobGradient;

  _ModernCirclePainter({
    required this.percentage,
    required this.strokeWidth,
    required this.gradientColors,
    required this.borderColor,
    required this.borderWidth,
    required this.tickColor,
    required this.ticks,
    required this.showTicks,
    required this.knobSize,
    required this.knobGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2 - 8;

    // Background track
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Subtle border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawCircle(
      center,
      radius + strokeWidth / 2 + borderWidth / 2 - 2,
      borderPaint,
    );

    // Tick marks
    if (showTicks && ticks > 0) {
      final tickPaint = Paint()
        ..color = tickColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < ticks; i++) {
        double angle = -pi / 2 + (i / ticks) * 2 * pi;
        final inner = Offset(
          center.dx + (radius - strokeWidth / 2 + 6) * cos(angle),
          center.dy + (radius - strokeWidth / 2 + 6) * sin(angle),
        );
        final outer = Offset(
          center.dx + (radius + strokeWidth / 2 - 6) * cos(angle),
          center.dy + (radius + strokeWidth / 2 - 6) * sin(angle),
        );
        canvas.drawLine(inner, outer, tickPaint);
      }
    }

    // Progress arc with sweep gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = percentage.clamp(0.0, 1.0) * 2 * pi;

    // Make gradient intentionally very soft
    final lightColors = gradientColors.map((c) => c.withOpacity(0.7)).toList();

    // This ensures the first color always starts at 12 o'clock (-90 degrees)
    final gradient = SweepGradient(
      startAngle: 0.1,
      endAngle: 2 * pi,
      colors: lightColors,
      transform: const GradientRotation(-pi / 1.8),
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw the arc starting from top (-pi / 2)
    canvas.drawArc(rect, -pi / 2, sweep, false, progressPaint);

    // Animated knob
    final knobAngle = -pi / 2 + sweep;
    final knobCenter = Offset(
      center.dx + radius * cos(knobAngle),
      center.dy + radius * sin(knobAngle),
    );

    // Knob shadow
    canvas.drawCircle(
      knobCenter,
      knobSize + 3,
      Paint()..color = Colors.black.withOpacity(0.10),
    );

    // Knob gradient
    final knobShader = ui.Gradient.radial(
      knobCenter,
      knobSize,
      knobGradient,
      [0.0, 1.0],
    );

    final knobPaint = Paint()
      ..shader = knobShader
      ..style = PaintingStyle.fill;

    // Knob border
    final knobBorderPaint = Paint()
      ..color = gradientColors.last.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(knobCenter, knobSize, knobBorderPaint);
    canvas.drawCircle(knobCenter, knobSize - 2, knobPaint);
  }

  @override
  bool shouldRepaint(covariant _ModernCirclePainter old) =>
      old.percentage != percentage ||
      old.gradientColors != gradientColors ||
      old.strokeWidth != strokeWidth;
}
