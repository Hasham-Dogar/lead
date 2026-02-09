import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;

  const CalendarDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<CalendarDatePicker> createState() => _CalendarDatePickerState();
}

class _CalendarDatePickerState extends State<CalendarDatePicker> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('MMMM yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Select Date',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Header with month dropdown and navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      monthFormat.format(_currentMonth),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month - 1,
                          );
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Weekday headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _WeekdayHeader('S'),
                _WeekdayHeader('M'),
                _WeekdayHeader('T'),
                _WeekdayHeader('W'),
                _WeekdayHeader('T'),
                _WeekdayHeader('F'),
                _WeekdayHeader('S'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Calendar grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCalendarGrid(),
            ),
          ),
          // Action buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFC6060),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      widget.onDateSelected(_selectedDate);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startingDayOfWeek = firstDay.weekday == 7 ? 0 : firstDay.weekday;

    final days = <Widget>[];

    // Previous month days to fill the first week
    final previousMonthLastDay = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      0,
    ).day;

    for (int i = startingDayOfWeek - 1; i >= 0; i--) {
      final day = previousMonthLastDay - i;
      days.add(
        _CalendarDayButton(
          dayNumber: day,
          isOtherMonth: true,
          isToday: false,
          isSelected: false,
          isEnabled: false,
          onTap: () {},
        ),
      );
    }

    // Days of the current month
    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isToday =
          DateTime.now().day == day &&
          DateTime.now().month == _currentMonth.month &&
          DateTime.now().year == _currentMonth.year;
      final isSelected =
          _selectedDate.day == day &&
          _selectedDate.month == _currentMonth.month &&
          _selectedDate.year == _currentMonth.year;
      final isEnabled =
          date.isAfter(widget.firstDate.subtract(const Duration(days: 1))) &&
          date.isBefore(widget.lastDate.add(const Duration(days: 1)));

      days.add(
        _CalendarDayButton(
          dayNumber: day,
          isOtherMonth: false,
          isToday: isToday,
          isSelected: isSelected,
          isEnabled: isEnabled,
          onTap: isEnabled
              ? () {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              : () {},
        ),
      );
    }

    // Next month days to fill the last week
    final remainingCells = (7 - (days.length % 7)) % 7;
    for (int day = 1; day <= remainingCells; day++) {
      days.add(
        _CalendarDayButton(
          dayNumber: day,
          isOtherMonth: true,
          isToday: false,
          isSelected: false,
          isEnabled: false,
          onTap: () {},
        ),
      );
    }

    // Build grid rows
    final rows = <Widget>[];
    for (int i = 0; i < days.length; i += 7) {
      rows.add(
        Row(
          children: days
              .sublist(i, i + 7 <= days.length ? i + 7 : days.length)
              .map((day) => Expanded(child: day))
              .toList(),
        ),
      );
      if (i + 7 < days.length) {
        rows.add(const SizedBox(height: 4));
      }
    }

    return Column(children: rows);
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String day;

  const _WeekdayHeader(this.day);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

class _CalendarDayButton extends StatelessWidget {
  final int dayNumber;
  final bool isOtherMonth;
  final bool isToday;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _CalendarDayButton({
    required this.dayNumber,
    required this.isOtherMonth,
    required this.isToday,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFC6060)
              : (isToday
                    ? const Color(0xFFFFE5E5)
                    : Colors.transparent),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            dayNumber.toString(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: isOtherMonth
                  ? Colors.grey.shade300
                  : (isSelected
                        ? Colors.white
                        : (isEnabled ? Colors.black : Colors.grey.shade400)),
            ),
          ),
        ),
      ),
    );
  }
}
