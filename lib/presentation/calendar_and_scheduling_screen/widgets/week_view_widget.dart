import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeekViewWidget extends StatelessWidget {
  final DateTime currentWeek;
  final List<Map<String, dynamic>> events;
  final List<Map<String, dynamic>> staffList;
  final Function(DateTime, Map<String, dynamic>) onEventTap;

  const WeekViewWidget({
    super.key,
    required this.currentWeek,
    required this.events,
    required this.staffList,
    required this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays(currentWeek);

    return Container(
      height: 70.h,
      child: Column(
        children: [
          _buildWeekHeader(weekDays),
          Expanded(
            child: Row(
              children: [
                _buildTimeColumn(),
                Expanded(
                  child: _buildWeekGrid(weekDays),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader(List<DateTime> weekDays) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 15.w), // Space for time column
          ...weekDays
              .map((day) => Expanded(
                    child: Column(
                      children: [
                        Text(
                          _getBengaliWeekday(day.weekday),
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: _isToday(day)
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: _isToday(day)
                                    ? AppTheme.lightTheme.colorScheme.onPrimary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: _isToday(day)
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTimeColumn() {
    return Container(
      width: 15.w,
      child: Column(
        children: List.generate(12, (index) {
          final hour = index + 8; // Start from 8 AM
          return Container(
            height: 8.h,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWeekGrid(List<DateTime> weekDays) {
    return SingleChildScrollView(
      child: Container(
        height: 96.h, // 12 hours * 8.h
        child: Stack(
          children: [
            // Grid lines
            Column(
              children: List.generate(
                  12,
                  (index) => Container(
                        height: 8.h,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                      )),
            ),
            // Day columns
            Row(
              children: weekDays
                  .map((day) => Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          child: _buildDayEvents(day),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayEvents(DateTime day) {
    final dayEvents = events.where((event) {
      final eventDate = event['date'] as DateTime;
      return _isSameDay(eventDate, day);
    }).toList();

    return Stack(
      children: dayEvents.map((event) {
        final timeSlot = event['timeSlot'] as String;
        final startHour = _parseTimeSlot(timeSlot);
        final topPosition = (startHour - 8) * 8.h;

        return Positioned(
          top: topPosition,
          left: 1.w,
          right: 1.w,
          child: GestureDetector(
            onTap: () => onEventTap(day, event),
            child: Container(
              height: 6.h,
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: _getStatusColor(event['status'] as String)
                    .withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _getStatusColor(event['status'] as String),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event['clientName'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    timeSlot,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 10.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<DateTime> _getWeekDays(DateTime currentWeek) {
    final startOfWeek =
        currentWeek.subtract(Duration(days: currentWeek.weekday % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String _getBengaliWeekday(int weekday) {
    const weekdays = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র', 'শনি'];
    return weekdays[weekday % 7];
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  double _parseTimeSlot(String timeSlot) {
    // Parse time slot like "10:00 AM - 12:00 PM" to get start hour
    final parts = timeSlot.split(' - ');
    if (parts.isNotEmpty) {
      final timePart = parts[0].trim();
      final hourStr = timePart.split(':')[0];
      double hour = double.tryParse(hourStr) ?? 8.0;

      if (timePart.contains('PM') && hour != 12) {
        hour += 12;
      } else if (timePart.contains('AM') && hour == 12) {
        hour = 0;
      }

      return hour;
    }
    return 8.0; // Default to 8 AM
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppTheme.getSuccessColor(true);
      case 'pending':
        return AppTheme.getWarningColor(true);
      case 'conflict':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
