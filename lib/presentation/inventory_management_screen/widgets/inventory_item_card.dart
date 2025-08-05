import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InventoryItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onRightSwipe;
  final VoidCallback? onLeftSwipe;
  final bool isSelected;

  const InventoryItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onLongPress,
    this.onRightSwipe,
    this.onLeftSwipe,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = (item['stock'] as int) <= 5;
    final String status = item['status'] as String;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Dismissible(
        key: Key('item_${item['id']}'),
        background: Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 4.w),
          child: CustomIconWidget(
            iconName: 'edit',
            color: Colors.white,
            size: 6.w,
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: status == 'Available'
                ? AppTheme.warningLight
                : AppTheme.lightTheme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 4.w),
          child: CustomIconWidget(
            iconName: status == 'Available' ? 'block' : 'check_circle',
            color: Colors.white,
            size: 6.w,
          ),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd &&
              onRightSwipe != null) {
            onRightSwipe!();
          } else if (direction == DismissDirection.endToStart &&
              onLeftSwipe != null) {
            onLeftSwipe!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.getBorderColor(true),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomImageWidget(
                      imageUrl: item['image'] as String,
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isLowStock)
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'কম স্টক',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (isSelected)
                    Positioned(
                      top: 2.w,
                      left: 2.w,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 4.w,
                        ),
                      ),
                    ),
                ],
              ),

              // Content section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item name
                      Text(
                        item['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      // Stock quantity
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'inventory',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'স্টক: ${item['stock']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isLowStock
                                  ? AppTheme.errorLight
                                  : AppTheme.textSecondaryLight,
                              fontWeight: isLowStock
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Rental rate
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'attach_money',
                            color: AppTheme.secondaryLight,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '৳${item['rentalRate']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.secondaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Status badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getStatusColor(status),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _getStatusText(status),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
