import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetSummaryCard extends StatefulWidget {
  final Map<String, int> selectedItems;
  final TextEditingController advanceController;
  final double totalAmount;
  final Function(double) onTotalAmountChanged;

  const BudgetSummaryCard({
    super.key,
    required this.selectedItems,
    required this.advanceController,
    required this.totalAmount,
    required this.onTotalAmountChanged,
  });

  @override
  State<BudgetSummaryCard> createState() => _BudgetSummaryCardState();
}

class _BudgetSummaryCardState extends State<BudgetSummaryCard> {
  final Map<String, Map<String, dynamic>> itemPrices = {
    'flowers': {'name': 'ফুল', 'price': 500.0, 'unit': 'সেট'},
    'lights': {'name': 'লাইট', 'price': 800.0, 'unit': 'সেট'},
    'chairs': {'name': 'চেয়ার', 'price': 50.0, 'unit': 'পিস'},
    'stage': {'name': 'স্টেজ', 'price': 2000.0, 'unit': 'সেট'},
    'sound_system': {'name': 'সাউন্ড সিস্টেম', 'price': 1500.0, 'unit': 'সেট'},
    'table': {'name': 'টেবিল', 'price': 100.0, 'unit': 'পিস'},
  };

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  @override
  void didUpdateWidget(BudgetSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItems != widget.selectedItems) {
      _calculateTotal();
    }
  }

  void _calculateTotal() {
    double total = 0.0;
    widget.selectedItems.forEach((itemId, quantity) {
      if (itemPrices.containsKey(itemId) && quantity > 0) {
        total += (itemPrices[itemId]!['price'] as double) * quantity;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTotalAmountChanged(total);
    });
  }

  @override
  Widget build(BuildContext context) {
    final advanceAmount = double.tryParse(widget.advanceController.text) ?? 0.0;
    final remainingAmount = widget.totalAmount - advanceAmount;

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
                  iconName: 'receipt_long',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'বাজেট সারসংক্ষেপ',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildItemizedCosts(),
            if (widget.selectedItems.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Divider(color: AppTheme.lightTheme.colorScheme.outline),
              SizedBox(height: 2.h),
              _buildTotalAmount(),
              SizedBox(height: 2.h),
              _buildAdvancePaymentField(),
              SizedBox(height: 2.h),
              _buildRemainingAmount(remainingAmount),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemizedCosts() {
    if (widget.selectedItems.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                'কোনো আইটেম নির্বাচিত হয়নি',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: widget.selectedItems.entries
          .where((entry) => entry.value > 0)
          .map((entry) => _buildItemRow(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildItemRow(String itemId, int quantity) {
    final item = itemPrices[itemId];
    if (item == null) return const SizedBox.shrink();

    final price = item['price'] as double;
    final total = price * quantity;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${item['name']} × $quantity ${item['unit']}',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '৳${_formatBengaliNumber(total.toInt())}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'মোট পরিমাণ:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '৳${_formatBengaliNumber(widget.totalAmount.toInt())}',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancePaymentField() {
    return TextFormField(
      controller: widget.advanceController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'অগ্রিম পেমেন্ট',
        hintText: 'অগ্রিম পরিমাণ লিখুন',
        prefixText: '৳ ',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'payments',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final amount = double.tryParse(value);
          if (amount == null || amount < 0) {
            return 'সঠিক পরিমাণ লিখুন';
          }
          if (amount > widget.totalAmount) {
            return 'অগ্রিম পেমেন্ট মোট পরিমাণের চেয়ে বেশি হতে পারে না';
          }
        }
        return null;
      },
    );
  }

  Widget _buildRemainingAmount(double remainingAmount) {
    final isNegative = remainingAmount < 0;
    final isZero = remainingAmount == 0;

    Color backgroundColor;
    Color textColor;
    String label;

    if (isZero) {
      backgroundColor = AppTheme.getSuccessColor(true).withValues(alpha: 0.1);
      textColor = AppTheme.getSuccessColor(true);
      label = 'সম্পূর্ণ পরিশোধিত';
    } else if (isNegative) {
      backgroundColor =
          AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
      textColor = AppTheme.lightTheme.colorScheme.error;
      label = 'অতিরিক্ত পেমেন্ট:';
    } else {
      backgroundColor = AppTheme.getWarningColor(true).withValues(alpha: 0.1);
      textColor = AppTheme.getWarningColor(true);
      label = 'বকেয়া পরিমাণ:';
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!isZero)
            Text(
              '৳${_formatBengaliNumber(remainingAmount.abs().toInt())}',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  String _formatBengaliNumber(int number) {
    final String numberStr = number.toString();
    final List<String> bengaliDigits = [
      '০',
      '১',
      '২',
      '৩',
      '৪',
      '৫',
      '৬',
      '৭',
      '৮',
      '৯'
    ];

    String result = '';
    for (int i = 0; i < numberStr.length; i++) {
      final digit = int.parse(numberStr[i]);
      result += bengaliDigits[digit];
    }

    // Add comma separators for thousands
    if (result.length > 3) {
      final reversed = result.split('').reversed.toList();
      for (int i = 3; i < reversed.length; i += 4) {
        reversed.insert(i, ',');
      }
      result = reversed.reversed.join('');
    }

    return result;
  }
}
