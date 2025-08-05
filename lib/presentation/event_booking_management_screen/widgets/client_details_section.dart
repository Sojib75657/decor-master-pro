import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClientDetailsSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController addressController;
  final String? selectedEventType;
  final Function(String?) onEventTypeChanged;

  const ClientDetailsSection({
    super.key,
    required this.nameController,
    required this.mobileController,
    required this.addressController,
    required this.selectedEventType,
    required this.onEventTypeChanged,
  });

  @override
  State<ClientDetailsSection> createState() => _ClientDetailsSectionState();
}

class _ClientDetailsSectionState extends State<ClientDetailsSection> {
  final List<String> eventTypes = [
    'বিয়ে/Wedding',
    'জন্মদিন/Birthday',
    'কর্পোরেট/Corporate',
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
              'ক্লায়েন্ট বিবরণ',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildNameField(),
            SizedBox(height: 2.h),
            _buildMobileField(),
            SizedBox(height: 2.h),
            _buildEventTypeDropdown(),
            SizedBox(height: 2.h),
            _buildAddressField(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: widget.nameController,
      decoration: InputDecoration(
        labelText: 'নাম *',
        hintText: 'ক্লায়েন্টের পূর্ণ নাম লিখুন',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'নাম প্রয়োজন';
        }
        return null;
      },
    );
  }

  Widget _buildMobileField() {
    return TextFormField(
      controller: widget.mobileController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'মোবাইল নম্বর *',
        hintText: '01XXXXXXXXX',
        prefixText: '+880 ',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'phone',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'মোবাইল নম্বর প্রয়োজন';
        }
        if (value.length != 11 || !value.startsWith('01')) {
          return 'সঠিক মোবাইল নম্বর লিখুন';
        }
        return null;
      },
    );
  }

  Widget _buildEventTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: widget.selectedEventType,
      decoration: InputDecoration(
        labelText: 'ইভেন্টের ধরন *',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'event',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
      ),
      items: eventTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: widget.onEventTypeChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ইভেন্টের ধরন নির্বাচন করুন';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: widget.addressController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'ঠিকানা *',
        hintText: 'ইভেন্টের স্থানের সম্পূর্ণ ঠিকানা লিখুন',
        prefixIcon: Padding(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ঠিকানা প্রয়োজন';
        }
        return null;
      },
    );
  }
}
