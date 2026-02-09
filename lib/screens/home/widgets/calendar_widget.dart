import 'package:flutter/material.dart';
import 'package:leads/models/lead.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  final List<Lead> leads;

  const CalendarWidget({super.key, required this.leads});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  // Group leads by date
  Map<DateTime, List<Lead>> _getLeadsByDate() {
    final Map<DateTime, List<Lead>> leadsByDate = {};

    for (var lead in widget.leads) {
      final leadDate = DateTime(
        lead.dateTime.year,
        lead.dateTime.month,
        lead.dateTime.day,
      );
      if (leadsByDate[leadDate] == null) {
        leadsByDate[leadDate] = [];
      }
      leadsByDate[leadDate]!.add(lead);
    }

    return leadsByDate;
  }

  @override
  Widget build(BuildContext context) {
    final leadsByDate = _getLeadsByDate();
    final monthFormat = DateFormat('MMMM yyyy');

    return Column(
      children: [
        // Header with month and navigation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthFormat.format(_currentMonth),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 20),
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
                    icon: const Icon(Icons.arrow_forward, size: 20),
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
        // Calendar grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              // Weekday headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              const SizedBox(height: 8),
              // Calendar days
              _buildCalendarGrid(leadsByDate),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(Map<DateTime, List<Lead>> leadsByDate) {
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
        _CalendarDay(
          dayNumber: day,
          leadsCount: 0,
          hasLeads: false,
          isToday: false,
          isOtherMonth: true,
          onViewTap: null,
        ),
      );
    }

    // Days of the current month
    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final leadsForDay = leadsByDate[date] ?? [];
      final isToday =
          DateTime.now().day == day &&
          DateTime.now().month == _currentMonth.month &&
          DateTime.now().year == _currentMonth.year;

      days.add(
        _CalendarDay(
          dayNumber: day,
          leadsCount: leadsForDay.length,
          hasLeads: leadsForDay.isNotEmpty,
          isToday: isToday,
          isOtherMonth: false,
          onViewTap: leadsForDay.isNotEmpty
              ? () => _showLeadsForDay(date, leadsForDay)
              : null,
        ),
      );
    }

    // Next month days to fill the last week
    final remainingCells = (7 - (days.length % 7)) % 7;
    for (int day = 1; day <= remainingCells; day++) {
      days.add(
        _CalendarDay(
          dayNumber: day,
          leadsCount: 0,
          hasLeads: false,
          isToday: false,
          isOtherMonth: true,
          onViewTap: null,
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
              .map(
                (day) => Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                    ),
                    child: day,
                  ),
                ),
              )
              .toList(),
        ),
      );
      if (i + 7 <= days.length) {
        rows.add(const SizedBox(height: 0));
      }
    }

    return Column(children: rows);
  }

  void _showLeadsForDay(DateTime date, List<Lead> leads) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM dd, yyyy').format(date),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: leads.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final lead = leads[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${lead.dateTime.hour.toString().padLeft(2, '0')}:${lead.dateTime.minute.toString().padLeft(2, '0')} - ${lead.contactName}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String day;

  const _WeekdayHeader(this.day);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      child: Center(
        child: Text(
          day,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final int? dayNumber;
  final int leadsCount;
  final bool hasLeads;
  final bool isToday;
  final bool isOtherMonth;
  final VoidCallback? onViewTap;

  const _CalendarDay({
    required this.dayNumber,
    required this.leadsCount,
    required this.hasLeads,
    this.isToday = false,
    this.isOtherMonth = false,
    this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: dayNumber == null
          ? const SizedBox()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isToday
                        ? const Color(0xFFFC6060)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      dayNumber.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                        color: isToday
                            ? Colors.white
                            : (isOtherMonth
                                  ? Colors.grey.shade400
                                  : Colors.black),
                      ),
                    ),
                  ),
                ),
                if (hasLeads) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onViewTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFC6060),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'View',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (leadsCount > 1)
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 9,
                        color: const Color(0xFFFC6060),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}
