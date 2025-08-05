import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_status_section.dart';
import './widgets/budget_summary_card.dart';
import './widgets/client_details_section.dart';
import './widgets/date_time_picker_section.dart';
import './widgets/decoration_items_section.dart';
import './widgets/photo_attachment_section.dart';
import './widgets/staff_assignment_section.dart';

class EventBookingManagementScreen extends StatefulWidget {
  const EventBookingManagementScreen({super.key});

  @override
  State<EventBookingManagementScreen> createState() =>
      _EventBookingManagementScreenState();
}

class _EventBookingManagementScreenState
    extends State<EventBookingManagementScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController();

  // Form state
  String? _selectedEventType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Map<String, int> _selectedItems = {};
  double _totalAmount = 0.0;
  List<String> _selectedStaff = [];
  String _selectedStatus = 'pending';
  List<XFile> _attachedPhotos = [];

  bool _hasUnsavedChanges = false;
  bool _isAutoSaving = false;

  @override
  void initState() {
    super.initState();
    _setupAutoSave();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _advanceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupAutoSave() {
    _nameController.addListener(_markAsChanged);
    _mobileController.addListener(_markAsChanged);
    _addressController.addListener(_markAsChanged);
    _advanceController.addListener(_markAsChanged);
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
    _performAutoSave();
  }

  void _performAutoSave() {
    if (_isAutoSaving) return;

    setState(() {
      _isAutoSaving = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAutoSaving = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomActions(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'নতুন বুকিং',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: () => _onWillPop().then((shouldPop) {
          if (shouldPop) Navigator.of(context).pop();
        }),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      actions: [
        if (_isAutoSaving)
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Center(
              child: SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        if (_hasUnsavedChanges && !_isAutoSaving)
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Center(
              child: Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: AppTheme.getWarningColor(true),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 2.h),
        child: Column(
          children: [
            ClientDetailsSection(
              nameController: _nameController,
              mobileController: _mobileController,
              addressController: _addressController,
              selectedEventType: _selectedEventType,
              onEventTypeChanged: (value) {
                setState(() {
                  _selectedEventType = value;
                });
                _markAsChanged();
              },
            ),
            DateTimePickerSection(
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              onDateChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
                _markAsChanged();
              },
              onTimeChanged: (time) {
                setState(() {
                  _selectedTime = time;
                });
                _markAsChanged();
              },
            ),
            DecorationItemsSection(
              selectedItems: _selectedItems,
              onItemQuantityChanged: (itemId, quantity) {
                setState(() {
                  if (quantity > 0) {
                    _selectedItems[itemId] = quantity;
                  } else {
                    _selectedItems.remove(itemId);
                  }
                });
                _markAsChanged();
              },
            ),
            BudgetSummaryCard(
              selectedItems: _selectedItems,
              advanceController: _advanceController,
              totalAmount: _totalAmount,
              onTotalAmountChanged: (total) {
                setState(() {
                  _totalAmount = total;
                });
              },
            ),
            StaffAssignmentSection(
              selectedStaff: _selectedStaff,
              onStaffSelectionChanged: (staff) {
                setState(() {
                  _selectedStaff = staff;
                });
                _markAsChanged();
              },
            ),
            BookingStatusSection(
              selectedStatus: _selectedStatus,
              onStatusChanged: (status) {
                setState(() {
                  _selectedStatus = status;
                });
                _markAsChanged();
              },
            ),
            PhotoAttachmentSection(
              attachedPhotos: _attachedPhotos,
              onPhotosChanged: (photos) {
                setState(() {
                  _attachedPhotos = photos;
                });
                _markAsChanged();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancelBooking,
                child: Text('বাতিল'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4.w),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _saveBooking,
                child: Text('সংরক্ষণ করুন'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4.w),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('অসংরক্ষিত পরিবর্তন'),
        content: Text(
            'আপনার পরিবর্তনগুলি সংরক্ষিত হয়নি। আপনি কি নিশ্চিত যে আপনি ফিরে যেতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('থাকুন'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('ফিরে যান'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
        ],
      ),
    );

    return shouldDiscard ?? false;
  }

  void _cancelBooking() async {
    if (_hasUnsavedChanges) {
      final shouldDiscard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('বুকিং বাতিল'),
          content: Text('আপনি কি নিশ্চিত যে আপনি এই বুকিং বাতিল করতে চান?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('না'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('হ্যাঁ'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
      );

      if (shouldDiscard == true) {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  void _saveBooking() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "দয়া করে সব প্রয়োজনীয় তথ্য পূরণ করুন",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      Fluttertoast.showToast(
        msg: "দয়া করে তারিখ ও সময় নির্বাচন করুন",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_selectedItems.isEmpty) {
      Fluttertoast.showToast(
        msg: "দয়া করে কমপক্ষে একটি সাজসজ্জার আইটেম নির্বাচন করুন",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 2.h),
            Text('বুকিং সংরক্ষণ করা হচ্ছে...'),
          ],
        ),
      ),
    );

    // Simulate save operation
    await Future.delayed(const Duration(seconds: 2));

    // Generate booking ID
    final bookingId =
        'BK${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    // Close loading dialog
    Navigator.of(context).pop();

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.getSuccessColor(true),
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('বুকিং সফল'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('আপনার বুকিং সফলভাবে সংরক্ষিত হয়েছে।'),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    'বুকিং আইডি: ',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  Text(
                    bookingId,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'ক্লায়েন্টের কাছে SMS নিশ্চিতকরণ পাঠানো হয়েছে।',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('ঠিক আছে'),
          ),
        ],
      ),
    );

    // Reset form state
    setState(() {
      _hasUnsavedChanges = false;
    });
  }
}
