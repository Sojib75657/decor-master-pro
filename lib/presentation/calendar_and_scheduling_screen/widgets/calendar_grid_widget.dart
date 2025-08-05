import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalendarGridWidget extends StatelessWidget {
  final DateTime currentDate;
  final DateTime selectedDate;
  final List<Map<String, dynamic>> events;
  final Function(DateTime) onDateTapped;
  final Function(DateTime, Map<String, dynamic>) onEventLongPress;

  const CalendarGridWidget({
    super.key,
    required this.currentDate,
    required this.selectedDate,
    required this.events,
    required this.onDateTapped,
    required this.onEventLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      child: Column(
        children: [
          _buildWeekdayHeaders(),
          SizedBox(height: 1.h),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র', 'শনি'];

    return Row(
      children: weekdays
          .map((day) => Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentDate.year, currentDate.month, day);
      dayWidgets.add(_buildDayCell(date));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isToday = _isSameDay(date, DateTime.now());
    final isSelected = _isSameDay(date, selectedDate);
    final dayEvents = _getEventsForDate(date);

    return GestureDetector(
      onTap: () => onDateTapped(date),
      child: Container(
        margin: EdgeInsets.all(0.5.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : isToday
                  ? AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  width: 2,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : isToday
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight:
                    isToday || isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (dayEvents.isNotEmpty) ...[
              SizedBox(height: 0.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildEventIndicators(dayEvents),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEventIndicators(List<Map<String, dynamic>> dayEvents) {
    List<Widget> indicators = [];
    final maxIndicators = 3;

    for (int i = 0; i < dayEvents.length && i < maxIndicators; i++) {
      final event = dayEvents[i];
      final status = event['status'] as String;
      Color indicatorColor;

      switch (status) {
        case 'confirmed':
          indicatorColor = AppTheme.getSuccessColor(true);
          break;
        case 'pending':
          indicatorColor = AppTheme.getWarningColor(true);
          break;
        case 'conflict':
          indicatorColor = AppTheme.lightTheme.colorScheme.error;
          break;
        default:
          indicatorColor = AppTheme.lightTheme.colorScheme.primary;
      }

      indicators.add(
        Container(
          width: 1.5.w,
          height: 1.5.w,
          margin: EdgeInsets.symmetric(horizontal: 0.2.w),
          decoration: BoxDecoration(
            color: indicatorColor,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    if (dayEvents.length > maxIndicators) {
      indicators.add(
        Container(
          width: 1.5.w,
          height: 1.5.w,
          margin: EdgeInsets.symmetric(horizontal: 0.2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return indicators;
  }

  List<Map<String, dynamic>> _getEventsForDate(DateTime date) {
    return events.where((event) {
      final eventDate = event['date'] as DateTime;
      return _isSameDay(eventDate, date);
    }).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
