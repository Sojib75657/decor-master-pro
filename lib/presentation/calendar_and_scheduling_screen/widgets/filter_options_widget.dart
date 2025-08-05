import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterOptionsWidget extends StatelessWidget {
  final List<String> selectedEventTypes;
  final List<String> selectedStaff;
  final List<String> selectedStatuses;
  final Function(List<String>) onEventTypesChanged;
  final Function(List<String>) onStaffChanged;
  final Function(List<String>) onStatusesChanged;
  final VoidCallback onClearAll;
  final VoidCallback onApply;

  const FilterOptionsWidget({
    super.key,
    required this.selectedEventTypes,
    required this.selectedStaff,
    required this.selectedStatuses,
    required this.onEventTypesChanged,
    required this.onStaffChanged,
    required this.onStatusesChanged,
    required this.onClearAll,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'ফিল্টার অপশন',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    'সব মুছুন',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventTypeFilter(),
                  SizedBox(height: 3.h),
                  _buildStatusFilter(),
                  SizedBox(height: 3.h),
                  _buildStaffFilter(),
                ],
              ),
            ),
          ),
          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'ফিল্টার প্রয়োগ করুন',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTypeFilter() {
    final eventTypes = [
      {'value': 'wedding', 'label': 'বিবাহ অনুষ্ঠান', 'icon': 'favorite'},
      {'value': 'birthday', 'label': 'জন্মদিন', 'icon': 'cake'},
      {'value': 'corporate', 'label': 'কর্পোরেট ইভেন্ট', 'icon': 'business'},
      {'value': 'anniversary', 'label': 'বার্ষিকী', 'icon': 'celebration'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ইভেন্টের ধরন',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: eventTypes.map((type) {
            final isSelected = selectedEventTypes.contains(type['value']);
            return GestureDetector(
              onTap: () {
                final newSelection = List<String>.from(selectedEventTypes);
                if (isSelected) {
                  newSelection.remove(type['value']);
                } else {
                  newSelection.add(type['value'] as String);
                }
                onEventTypesChanged(newSelection);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: type['icon'] as String,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      type['label'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    final statuses = [
      {
        'value': 'confirmed',
        'label': 'নিশ্চিত',
        'color': AppTheme.getSuccessColor(true)
      },
      {
        'value': 'pending',
        'label': 'অপেক্ষমাণ',
        'color': AppTheme.getWarningColor(true)
      },
      {
        'value': 'conflict',
        'label': 'সংঘর্ষ',
        'color': AppTheme.lightTheme.colorScheme.error
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'বুকিং স্ট্যাটাস',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: statuses.map((status) {
            final isSelected = selectedStatuses.contains(status['value']);
            return GestureDetector(
              onTap: () {
                final newSelection = List<String>.from(selectedStatuses);
                if (isSelected) {
                  newSelection.remove(status['value']);
                } else {
                  newSelection.add(status['value'] as String);
                }
                onStatusesChanged(newSelection);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (status['color'] as Color)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: status['color'] as Color,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : (status['color'] as Color),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      status['label'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStaffFilter() {
    final staffMembers = [
      'রহিম উদ্দিন',
      'করিম আহমেদ',
      'নাসির হোসেন',
      'আব্দুল কাদের',
      'মোহাম্মদ আলী',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'কর্মী নির্বাচন',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Column(
          children: staffMembers.map((staff) {
            final isSelected = selectedStaff.contains(staff);
            return CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                final newSelection = List<String>.from(selectedStaff);
                if (value == true) {
                  newSelection.add(staff);
                } else {
                  newSelection.remove(staff);
                }
                onStaffChanged(newSelection);
              },
              title: Text(
                staff,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ),
      ],
    );
  }
}
