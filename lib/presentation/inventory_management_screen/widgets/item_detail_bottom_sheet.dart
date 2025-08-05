import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ItemDetailBottomSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemDetailBottomSheet({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.getBorderColor(true),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with actions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'আইটেমের বিস্তারিত',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onEdit,
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.errorLight,
                    size: 6.w,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondaryLight,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: AppTheme.getBorderColor(true)),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: item['image'] as String,
                      width: double.infinity,
                      height: 30.h,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Item name and category
                  Text(
                    item['name'] as String,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getCategoryLabel(item['category'] as String),
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Details grid
                  _buildDetailCard(
                    'স্টক পরিমাণ',
                    '${item['stock']} পিস',
                    'inventory',
                    (item['stock'] as int) <= 5
                        ? AppTheme.errorLight
                        : AppTheme.getSuccessColor(true),
                  ),

                  SizedBox(height: 2.h),

                  _buildDetailCard(
                    'ভাড়ার হার',
                    '৳${item['rentalRate']}',
                    'attach_money',
                    AppTheme.secondaryLight,
                  ),

                  SizedBox(height: 2.h),

                  _buildDetailCard(
                    'স্ট্যাটাস',
                    _getStatusText(item['status'] as String),
                    'info',
                    _getStatusColor(item['status'] as String),
                  ),

                  if (item['barcode'] != null &&
                      (item['barcode'] as String).isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    _buildDetailCard(
                      'বারকোড',
                      item['barcode'] as String,
                      'qr_code',
                      AppTheme.textSecondaryLight,
                    ),
                  ],

                  SizedBox(height: 3.h),

                  // Usage history section
                  Text(
                    'ব্যবহারের ইতিহাস',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  _buildUsageHistory(),

                  SizedBox(height: 3.h),

                  // Maintenance schedule
                  Text(
                    'রক্ষণাবেক্ষণের সময়সূচী',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  _buildMaintenanceSchedule(),

                  SizedBox(height: 3.h),

                  // Booking assignments
                  Text(
                    'বুকিং অ্যাসাইনমেন্ট',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  _buildBookingAssignments(),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
      String title, String value, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.getBorderColor(true)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageHistory() {
    final List<Map<String, dynamic>> usageHistory = [
      {
        'event': 'বিয়ের অনুষ্ঠান - রহিম ও সালমা',
        'date': '২৩ জুলাই ২০২৫',
        'quantity': 5,
        'status': 'সম্পন্ন',
      },
      {
        'event': 'জন্মদিনের পার্টি - আহমেদ পরিবার',
        'date': '১৮ জুলাই ২০২৫',
        'quantity': 3,
        'status': 'সম্পন্ন',
      },
      {
        'event': 'কর্পোরেট ইভেন্ট - ABC কোম্পানি',
        'date': '১৫ জুলাই ২০২৫',
        'quantity': 8,
        'status': 'সম্পন্ন',
      },
    ];

    return Column(
      children: usageHistory.map((usage) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.getBorderColor(true)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      usage['event'] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      usage['status'] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.getSuccessColor(true),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.textSecondaryLight,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    usage['date'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  CustomIconWidget(
                    iconName: 'inventory',
                    color: AppTheme.textSecondaryLight,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'পরিমাণ: ${usage['quantity']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMaintenanceSchedule() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.getBorderColor(true)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'build',
                color: AppTheme.warningLight,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'পরবর্তী রক্ষণাবেক্ষণ',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '৩০ জুলাই ২০২৫',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.warningLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'নিয়মিত পরিষ্কার এবং মানের পরীক্ষা',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingAssignments() {
    final List<Map<String, dynamic>> bookings = [
      {
        'event': 'বার্ষিকী উৎসব - করিম পরিবার',
        'date': '২৮ জুলাই ২০২৫',
        'quantity': 4,
        'status': 'নিশ্চিত',
      },
      {
        'event': 'গ্র্যাজুয়েশন পার্টি - ফাতেমা',
        'date': '০২ আগস্ট ২০২৫',
        'quantity': 6,
        'status': 'অপেক্ষমাণ',
      },
    ];

    return Column(
      children: bookings.map((booking) {
        final bool isConfirmed = booking['status'] == 'নিশ্চিত';

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.getBorderColor(true)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking['event'] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: (isConfirmed
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.warningLight)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      booking['status'] as String,
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: isConfirmed
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.warningLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'event',
                    color: AppTheme.textSecondaryLight,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    booking['date'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  CustomIconWidget(
                    iconName: 'inventory',
                    color: AppTheme.textSecondaryLight,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'প্রয়োজন: ${booking['quantity']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'Flowers':
        return 'ফুল';
      case 'Lights':
        return 'লাইট';
      case 'Chairs':
        return 'চেয়ার';
      case 'Stage':
        return 'স্টেজ';
      case 'Sound':
        return 'সাউন্ড';
      default:
        return category;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return AppTheme.getSuccessColor(true);
      case 'Used':
        return AppTheme.warningLight;
      case 'Maintenance':
        return AppTheme.errorLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Available':
        return 'উপলব্ধ';
      case 'Used':
        return 'ব্যবহৃত';
      case 'Maintenance':
        return 'রক্ষণাবেক্ষণ';
      default:
        return 'অজানা';
    }
  }
}
