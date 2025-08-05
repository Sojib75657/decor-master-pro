import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StaffAssignmentSection extends StatefulWidget {
  final List<String> selectedStaff;
  final Function(List<String>) onStaffSelectionChanged;

  const StaffAssignmentSection({
    super.key,
    required this.selectedStaff,
    required this.onStaffSelectionChanged,
  });

  @override
  State<StaffAssignmentSection> createState() => _StaffAssignmentSectionState();
}

class _StaffAssignmentSectionState extends State<StaffAssignmentSection> {
  final List<Map<String, dynamic>> availableStaff = [
    {
      'id': 'staff_001',
      'name': 'রহিম উদ্দিন',
      'specialization': 'ফুল সাজানো',
      'phone': '01712345678',
      'experience': '৫ বছর',
      'rating': 4.8,
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'isAvailable': true,
    },
    {
      'id': 'staff_002',
      'name': 'ফাতেমা খাতুন',
      'specialization': 'লাইট সেটআপ',
      'phone': '01798765432',
      'experience': '৩ বছর',
      'rating': 4.6,
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'isAvailable': true,
    },
    {
      'id': 'staff_003',
      'name': 'করিম মিয়া',
      'specialization': 'স্টেজ ডিজাইন',
      'phone': '01856789012',
      'experience': '৭ বছর',
      'rating': 4.9,
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'isAvailable': false,
    },
    {
      'id': 'staff_004',
      'name': 'সালমা বেগম',
      'specialization': 'সাউন্ড সিস্টেম',
      'phone': '01634567890',
      'experience': '৪ বছর',
      'rating': 4.7,
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'isAvailable': true,
    },
    {
      'id': 'staff_005',
      'name': 'আব্দুল হক',
      'specialization': 'সার্বিক ব্যবস্থাপনা',
      'phone': '01923456789',
      'experience': '১০ বছর',
      'rating': 5.0,
      'avatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'isAvailable': true,
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
                  iconName: 'group',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'স্টাফ নিয়োগ',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              '${widget.selectedStaff.length} জন স্টাফ নির্বাচিত',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableStaff.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final staff = availableStaff[index];
                final isSelected = widget.selectedStaff.contains(staff['id']);
                final isAvailable = staff['isAvailable'] as bool;

                return _buildStaffCard(staff, isSelected, isAvailable);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffCard(
      Map<String, dynamic> staff, bool isSelected, bool isAvailable) {
    return InkWell(
      onTap: isAvailable ? () => _toggleStaffSelection(staff['id']) : null,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: !isAvailable
              ? AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5)
              : isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: !isAvailable
                ? AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.5)
                : isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: staff['avatar'],
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (!isAvailable)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'block',
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          staff['name'],
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: !isAvailable
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                      ),
                      if (isAvailable)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.w),
                          decoration: BoxDecoration(
                            color: AppTheme.getSuccessColor(true)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'উপলব্ধ',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.getSuccessColor(true),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.error
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ব্যস্ত',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    staff['specialization'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: !isAvailable
                          ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          : AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.getWarningColor(true),
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${staff['rating']}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: !isAvailable
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : null,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'work',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        staff['experience'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: !isAvailable
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isAvailable)
              Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  _toggleStaffSelection(staff['id']);
                },
                activeColor: AppTheme.lightTheme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  void _toggleStaffSelection(String staffId) {
    final List<String> updatedSelection = List.from(widget.selectedStaff);

    if (updatedSelection.contains(staffId)) {
      updatedSelection.remove(staffId);
    } else {
      updatedSelection.add(staffId);
    }

    widget.onStaffSelectionChanged(updatedSelection);
  }
}
