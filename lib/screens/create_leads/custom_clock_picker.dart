import 'dart:math';
import 'package:flutter/material.dart';

/// Enum to manage the current selection mode (hour or minute).
enum _ClockPickerMode { hour, minute }

class CustomClockPicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final void Function(TimeOfDay) onSave;

  const CustomClockPicker({
    super.key,
    required this.initialTime,
    required this.onSave,
  });

  @override
  State<CustomClockPicker> createState() => _CustomClockPickerState();
}

class _CustomClockPickerState extends State<CustomClockPicker> {
  late int selectedHour; // 1-12 for display
  late int selectedMinute; // 0-59
  late bool isPm;
  late _ClockPickerMode _currentMode;

  static const double _clockSize = 175.0;
  // Define the custom color for consistency
  static const Color _customPrimaryColor = Color.fromRGBO(252, 96, 96, 1.0);

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hourOfPeriod;
    selectedMinute = widget.initialTime.minute;
    isPm = widget.initialTime.period == DayPeriod.pm;
    _currentMode = _ClockPickerMode.hour; // Start with hour selection
  }

  void _handleTimeSelection(Offset localPosition) {
    final center = Offset(_clockSize / 2, _clockSize / 2);
    final vector = localPosition - center;

    // Calculate angle relative to the center.
    // atan2(y, x) gives angle from positive x-axis, counter-clockwise.
    // 0 degrees is to the right (3 o'clock).
    double angle = atan2(vector.dy, vector.dx);

    // Adjust angle so 12 o'clock (top) is 0, and it increases clockwise.
    angle += pi / 2; // Rotate by 90 degrees counter-clockwise
    if (angle < 0) {
      angle += 2 * pi; // Ensure angle is in [0, 2*pi)
    }

    setState(() {
      if (_currentMode == _ClockPickerMode.hour) {
        int newHour = ((angle / (2 * pi)) * 12).round();
        if (newHour == 0) {
          newHour = 12; // Map 0 (which would be 12 o'clock) to 12
        }
        selectedHour = newHour;
      } else {
        // _currentMode == _ClockPickerMode.minute
        final int newMinute = ((angle / (2 * pi)) * 60).round() % 60;
        selectedMinute = newMinute;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Set time",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                /// Display selected time and mode toggles
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () =>
                          setState(() => _currentMode = _ClockPickerMode.hour),
                      child: Text(
                        selectedHour.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: _currentMode == _ClockPickerMode.hour
                              ? _customPrimaryColor
                              : Colors.black54,
                        ),
                      ),
                    ),
                    const Text(
                      ":",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(
                        () => _currentMode = _ClockPickerMode.minute,
                      ),
                      child: Text(
                        selectedMinute.toString().padLeft(2, '0'),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: _currentMode == _ClockPickerMode.minute
                              ? _customPrimaryColor
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                /// Clock UI with gesture detection
                GestureDetector(
                  onTapUp: (TapUpDetails details) {
                    _handleTimeSelection(details.localPosition);
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    _handleTimeSelection(details.localPosition);
                  },
                  child: SizedBox(
                    width: _clockSize,
                    height: _clockSize,
                    child: CustomPaint(
                      painter: ClockPainter(
                        selectedHour,
                        selectedMinute,
                        isPm, // Pass isPm to the painter for AM/PM calculation
                        _currentMode,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// AM/PM Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ChoiceChip(
                      label: const Text("AM"),
                      selected: !isPm,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() => isPm = false);
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("PM"),
                      selected: isPm,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() => isPm = true);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _customPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      int finalHour =
                          selectedHour % 12; // Convert 12 to 0 for AM/PM logic
                      if (isPm && selectedHour != 12) {
                        finalHour += 12;
                      } else if (!isPm && selectedHour == 12) {
                        // 12 AM is hour 0
                        finalHour = 0;
                      }
                      widget.onSave(
                        TimeOfDay(hour: finalHour, minute: selectedMinute),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final int selectedHour; // 1-12
  final int selectedMinute; // 0-59
  final bool isPm;
  final _ClockPickerMode currentMode;

  ClockPainter(
    this.selectedHour,
    this.selectedMinute,
    this.isPm,
    this.currentMode,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final hourHandPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final minuteHandPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    /// Draw Clock Numbers 1–12
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 1; i <= 12; i++) {
      final double angle = (i - 3) * 30 * pi / 180;
      final offset = Offset(
        center.dx + cos(angle) * (radius - 15), // Adjust position for numbers
        center.dy + sin(angle) * (radius - 15),
      );

      // The previous logic for `isCurrentHour` and conditional styling is removed.
      textPainter.text = TextSpan(
        text: "$i",
        style: const TextStyle(
          color: Colors.black, // Always black
          fontSize: 16,
          fontWeight: FontWeight.normal, // Always normal weight
        ),
      );
      textPainter.layout();
      // The drawing of the highlight circle is removed.
      textPainter.paint(
        canvas,
        offset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    /// Hour Hand
    // Calculate actual hour for hand position (0-11 for AM, 12-23 for PM)
    int actualHour = selectedHour;
    if (isPm && selectedHour != 12) {
      actualHour += 12;
    } else if (!isPm && selectedHour == 12) {
      actualHour = 0; // 12 AM is 0 hour
    }

    final double hourAngleDegrees =
        (actualHour % 12 * 30) + (selectedMinute * 0.5);
    final double hourAngle = (hourAngleDegrees * pi / 180) - pi / 2;
    final Offset hourEnd = Offset(
      center.dx + cos(hourAngle) * (radius * 0.45),
      center.dy + sin(hourAngle) * (radius * 0.45),
    );
    canvas.drawLine(center, hourEnd, hourHandPaint);

    /// Minute Hand
    final double minuteAngleDegrees = selectedMinute * 6;
    final double minuteAngle = (minuteAngleDegrees * pi / 180) - pi / 2;
    final Offset minEnd = Offset(
      center.dx + cos(minuteAngle) * (radius * 0.7),
      center.dy + sin(minuteAngle) * (radius * 0.7),
    );
    canvas.drawLine(center, minEnd, minuteHandPaint);
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return oldDelegate.selectedHour != selectedHour ||
        oldDelegate.selectedMinute != selectedMinute ||
        oldDelegate.isPm != isPm ||
        oldDelegate.currentMode != currentMode;
  }
}
