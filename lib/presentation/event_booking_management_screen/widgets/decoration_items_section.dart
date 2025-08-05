import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DecorationItemsSection extends StatefulWidget {
  final Map<String, int> selectedItems;
  final Function(String, int) onItemQuantityChanged;

  const DecorationItemsSection({
    super.key,
    required this.selectedItems,
    required this.onItemQuantityChanged,
  });

  @override
  State<DecorationItemsSection> createState() => _DecorationItemsSectionState();
}

class _DecorationItemsSectionState extends State<DecorationItemsSection> {
  final List<Map<String, dynamic>> decorationItems = [
    {
      'id': 'flowers',
      'name': 'ফুল',
      'nameEn': 'Flowers',
      'price': 500.0,
      'unit': 'সেট',
      'icon': 'local_florist',
      'image':
          'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'id': 'lights',
      'name': 'লাইট',
      'nameEn': 'Lights',
      'price': 800.0,
      'unit': 'সেট',
      'icon': 'lightbulb',
      'image':
          'https://images.pexels.com/photos/1123262/pexels-photo-1123262.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'id': 'chairs',
      'name': 'চেয়ার',
      'nameEn': 'Chairs',
      'price': 50.0,
      'unit': 'পিস',
      'icon': 'chair',
      'image':
          'https://images.pexels.com/photos/116910/pexels-photo-116910.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'id': 'stage',
      'name': 'স্টেজ',
      'nameEn': 'Stage',
      'price': 2000.0,
      'unit': 'সেট',
      'icon': 'stage',
      'image':
          'https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'id': 'sound_system',
      'name': 'সাউন্ড সিস্টেম',
      'nameEn': 'Sound System',
      'price': 1500.0,
      'unit': 'সেট',
      'icon': 'speaker',
      'image':
          'https://images.pexels.com/photos/164938/pexels-photo-164938.jpeg?auto=compress&cs=tinysrgb&w=400',
    },
    {
      'id': 'table',
      'name': 'টেবিল',
      'nameEn': 'Table',
      'price': 100.0,
      'unit': 'পিস',
      'icon': 'table_restaurant',
      'image':
          'https://images.pexels.com/photos/1395967/pexels-photo-1395967.jpeg?auto=compress&cs=tinysrgb&w=400',
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
            Text(
              'সাজসজ্জার আইটেম',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 0.85,
              ),
              itemCount: decorationItems.length,
              itemBuilder: (context, index) {
                final item = decorationItems[index];
                final quantity = widget.selectedItems[item['id']] ?? 0;
                return _buildItemCard(item, quantity);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, int quantity) {
    final isSelected = quantity > 0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
            : AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: item['image'],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '৳${_formatPrice(item['price'])}/${item['unit']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  _buildQuantityControls(item['id'], quantity),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(String itemId, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap:
              quantity > 0 ? () => _decreaseQuantity(itemId, quantity) : null,
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: quantity > 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomIconWidget(
              iconName: 'remove',
              color: quantity > 0
                  ? AppTheme.lightTheme.colorScheme.onPrimary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            quantity.toString(),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        InkWell(
          onTap: () => _increaseQuantity(itemId, quantity),
          child: Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  void _increaseQuantity(String itemId, int currentQuantity) {
    widget.onItemQuantityChanged(itemId, currentQuantity + 1);
  }

  void _decreaseQuantity(String itemId, int currentQuantity) {
    if (currentQuantity > 0) {
      widget.onItemQuantityChanged(itemId, currentQuantity - 1);
    }
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}k';
    }
    return price.toStringAsFixed(0);
  }
}
