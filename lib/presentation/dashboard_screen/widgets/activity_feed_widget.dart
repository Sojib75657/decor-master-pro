import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityFeedWidget extends StatelessWidget {
  const ActivityFeedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {
        "id": 1,
        "type": "booking",
        "title": "নতুন বুকিং",
        "description": "রহিম সাহেবের বিয়ের অনুষ্ঠান - ২৫ জুলাই",
        "time": "২ ঘন্টা আগে",
        "icon": "event",
        "color": AppTheme.lightTheme.colorScheme.primary,
      },
      {
        "id": 2,
        "type": "payment",
        "title": "পেমেন্ট গৃহীত",
        "description": "করিম সাহেব - ৳১৫,০০০ অগ্রিম",
        "time": "৪ ঘন্টা আগে",
        "icon": "payment",
        "color": AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        "id": 3,
        "type": "staff",
        "title": "স্টাফ আপডেট",
        "description": "আলী ভাই কাজে যোগদান করেছেন",
        "time": "৬ ঘন্টা আগে",
        "icon": "person_add",
        "color": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "id": 4,
        "type": "booking",
        "title": "বুকিং সম্পন্ন",
        "description": "সালমা বেগমের হলুদ অনুষ্ঠান",
        "time": "১ দিন আগে",
        "icon": "check_circle",
        "color": AppTheme.lightTheme.colorScheme.tertiary,
      },
      {
        "id": 5,
        "type": "inventory",
        "title": "ইনভেন্টরি আপডেট",
        "description": "নতুন চেয়ার ৫০টি যোগ করা হয়েছে",
        "time": "২ দিন আগে",
        "icon": "inventory",
        "color": AppTheme.lightTheme.colorScheme.primary,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'সাম্প্রতিক কার্যক্রম',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full activity log
                },
                child: Text(
                  'সব দেখুন',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Dismissible(
                key: Key(activity["id"].toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'visibility',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
                onDismissed: (direction) {
                  // Handle swipe to view details
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${activity["title"]} এর বিস্তারিত দেখানো হচ্ছে'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: _buildActivityItem(activity),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: (activity["color"] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: activity["icon"] as String,
                color: activity["color"] as Color,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity["title"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity["description"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity["time"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
