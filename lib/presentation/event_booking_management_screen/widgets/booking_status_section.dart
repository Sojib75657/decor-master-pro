import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingStatusSection extends StatefulWidget {
  final String selectedStatus;
  final Function(String) onStatusChanged;

  const BookingStatusSection({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  State<BookingStatusSection> createState() => _BookingStatusSectionState();
}

class _BookingStatusSectionState extends State<BookingStatusSection> {
  final List<Map<String, dynamic>> statusOptions = [
    {
      'value': 'confirmed',
      'label': 'নিশ্চিত',
      'labelEn': 'Confirmed',
      'icon': 'check_circle',
      'color': Color(
          0xFF10B981), // Success green 'description': 'বুকিং নিশ্চিত করা হয়েছে',
    },
    {
      'value': 'pending',
      'label': 'অপেক্ষমাণ',
      'labelEn': 'Pending',
      'icon': 'schedule',
      'color': Color(
          0xFFF59E0B), // Warning orange 'description': 'নিশ্চিতকরণের অপেক্ষায়',
    },
    {
      'value': 'cancelled',
      'label': 'বাতিল',
      'labelEn': 'Cancelled',
      'icon': 'cancel',
      'color': Color(
          0xFFEF4444), // Error red 'description': 'বুকিং বাতিল করা হয়েছে',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'assignment',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'বুকিং স্ট্যাটাস',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Column(
              children: statusOptions.map((status) {
                final isSelected = widget.selectedStatus == status['value'];
                return Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: _buildStatusOption(status, isSelected),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(Map<String, dynamic> status, bool isSelected) {
    final statusColor = status['color'] as Color;

    return InkWell(
      onTap: () => widget.onStatusChanged(status['value']),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? statusColor.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? statusColor
                : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? statusColor
                    : statusColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: status['icon'],
                  color: isSelected ? Colors.white : statusColor,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status['label'],
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? statusColor
                          : AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    status['description'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 16,
                ),
              )
            else
              Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
