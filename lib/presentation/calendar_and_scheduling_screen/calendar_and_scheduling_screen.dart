import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calendar_grid_widget.dart';
import './widgets/calendar_header_widget.dart';
import './widgets/daily_timeline_widget.dart';
import './widgets/event_card_widget.dart';
import './widgets/event_context_menu_widget.dart';
import './widgets/filter_options_widget.dart';
import './widgets/week_view_widget.dart';

class CalendarAndSchedulingScreen extends StatefulWidget {
  const CalendarAndSchedulingScreen({super.key});

  @override
  State<CalendarAndSchedulingScreen> createState() =>
      _CalendarAndSchedulingScreenState();
}

class _CalendarAndSchedulingScreenState
    extends State<CalendarAndSchedulingScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String _selectedView = 'month';
  bool _isRefreshing = false;
  Map<String, dynamic>? _selectedEvent;
  bool _showContextMenu = false;
  bool _showFilters = false;

  // Filter states
  List<String> _selectedEventTypes = [];
  List<String> _selectedStaff = [];
  List<String> _selectedStatuses = [];

  // Mock data
  final List<Map<String, dynamic>> _events = [
    {
      "id": 1,
      "clientName": "আহমেদ হাসান",
      "eventType": "wedding",
      "date": DateTime.now().add(const Duration(days: 2)),
      "timeSlot": "10:00 AM - 4:00 PM",
      "venue": "ঢাকা কমিউনিটি সেন্টার, ধানমন্ডি",
      "status": "confirmed",
      "assignedStaff": ["রহিম উদ্দিন", "করিম আহমেদ", "নাসির হোসেন"],
      "budget": "৫০,০০০ টাকা",
      "advance": "২০,০০০ টাকা",
      "items": ["ফুল", "লাইট", "চেয়ার", "স্টেজ"]
    },
    {
      "id": 2,
      "clientName": "ফাতেমা খাতুন",
      "eventType": "birthday",
      "date": DateTime.now().add(const Duration(days: 5)),
      "timeSlot": "6:00 PM - 10:00 PM",
      "venue": "বাসা নং ১২, রোড ৫, ধানমন্ডি",
      "status": "pending",
      "assignedStaff": ["আব্দুল কাদের"],
      "budget": "১৫,০০০ টাকা",
      "advance": "৫,০০০ টাকা",
      "items": ["ব্যালুন", "কেক টেবিল", "লাইট"]
    },
    {
      "id": 3,
      "clientName": "রহমান এন্টারপ্রাইজ",
      "eventType": "corporate",
      "date": DateTime.now().add(const Duration(days: 7)),
      "timeSlot": "9:00 AM - 5:00 PM",
      "venue": "হোটেল সোনারগাঁও, ঢাকা",
      "status": "conflict",
      "assignedStaff": [
        "রহিম উদ্দিন",
        "করিম আহমেদ",
        "নাসির হোসেন",
        "মোহাম্মদ আলী"
      ],
      "budget": "১,২০,০০০ টাকা",
      "advance": "৫০,০০০ টাকা",
      "items": ["স্টেজ", "সাউন্ড সিস্টেম", "প্রজেক্টর", "চেয়ার"]
    },
    {
      "id": 4,
      "clientName": "সালমা বেগম",
      "eventType": "anniversary",
      "date": DateTime.now().add(const Duration(days: 10)),
      "timeSlot": "7:00 PM - 11:00 PM",
      "venue": "গুলশান ক্লাব, ঢাকা",
      "status": "confirmed",
      "assignedStaff": ["নাসির হোসেন", "আব্দুল কাদের"],
      "budget": "৩৫,০০০ টাকা",
      "advance": "১৫,০০০ টাকা",
      "items": ["ফুল", "লাইট", "ডেকোরেশন"]
    },
    {
      "id": 5,
      "clientName": "করিম ট্রেডার্স",
      "eventType": "corporate",
      "date": DateTime.now(),
      "timeSlot": "2:00 PM - 6:00 PM",
      "venue": "বিজনেস সেন্টার, মতিঝিল",
      "status": "confirmed",
      "assignedStaff": ["রহিম উদ্দিন", "মোহাম্মদ আলী"],
      "budget": "৮০,০০০ টাকা",
      "advance": "৩০,০০০ টাকা",
      "items": ["স্টেজ", "সাউন্ড সিস্টেম", "চেয়ার"]
    }
  ];

  final List<Map<String, dynamic>> _staffList = [
    {"name": "রহিম উদ্দিন", "specialization": "ডেকোরেশন", "available": true},
    {"name": "করিম আহমেদ", "specialization": "লাইটিং", "available": true},
    {"name": "নাসির হোসেন", "specialization": "সাউন্ড", "available": false},
    {"name": "আব্দুল কাদের", "specialization": "ফুল সাজানো", "available": true},
    {
      "name": "মোহাম্মদ আলী",
      "specialization": "স্টেজ সেটআপ",
      "available": true
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            CalendarHeaderWidget(
              currentMonth: _getBengaliMonth(_currentDate),
              onPreviousMonth: _goToPreviousMonth,
              onNextMonth: _goToNextMonth,
              onTodayPressed: _goToToday,
              selectedView: _selectedView,
              onViewChanged: _onViewChanged,
            ),
            Expanded(
              child: Stack(
                children: [
                  _buildMainContent(),
                  if (_showContextMenu && _selectedEvent != null)
                    _buildContextMenuOverlay(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewBooking,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          size: 6.w,
        ),
      ),
      bottomSheet: _showFilters ? _buildFilterSheet() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'ক্যালেন্ডার ও সময়সূচী',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => setState(() => _showFilters = !_showFilters),
          icon: CustomIconWidget(
            iconName: 'filter_list',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'dashboard',
              child: Text('ড্যাশবোর্ড'),
            ),
            const PopupMenuItem(
              value: 'booking',
              child: Text('বুকিং ম্যানেজমেন্ট'),
            ),
            const PopupMenuItem(
              value: 'staff',
              child: Text('স্টাফ ম্যানেজমেন্ট'),
            ),
            const PopupMenuItem(
              value: 'inventory',
              child: Text('ইনভেন্টরি'),
            ),
          ],
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    switch (_selectedView) {
      case 'week':
        return WeekViewWidget(
          currentWeek: _currentDate,
          events: _getFilteredEvents(),
          staffList: _staffList,
          onEventTap: _onEventTap,
        );
      case 'day':
        return DailyTimelineWidget(
          selectedDate: _selectedDate,
          dayEvents: _getEventsForDate(_selectedDate),
          onEventTap: _onEventSelected,
        );
      default:
        return Column(
          children: [
            CalendarGridWidget(
              currentDate: _currentDate,
              selectedDate: _selectedDate,
              events: _getFilteredEvents(),
              onDateTapped: _onDateTapped,
              onEventLongPress: _onEventLongPress,
            ),
            if (_getEventsForDate(_selectedDate).isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Text(
                      'আজকের ইভেন্ট',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_getEventsForDate(_selectedDate).length} টি',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _getEventsForDate(_selectedDate).length,
                  itemBuilder: (context, index) {
                    final event = _getEventsForDate(_selectedDate)[index];
                    return EventCardWidget(
                      event: event,
                      onTap: () => _onEventSelected(event),
                      onLongPress: () =>
                          _onEventLongPress(_selectedDate, event),
                    );
                  },
                ),
              ),
            ],
          ],
        );
    }
  }

  Widget _buildContextMenuOverlay() {
    return GestureDetector(
      onTap: () => setState(() => _showContextMenu = false),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: EventContextMenuWidget(
            event: _selectedEvent!,
            onEdit: _editEvent,
            onDuplicate: _duplicateEvent,
            onCancel: _cancelEvent,
            onViewDetails: _viewEventDetails,
            onClose: () => setState(() => _showContextMenu = false),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSheet() {
    return FilterOptionsWidget(
      selectedEventTypes: _selectedEventTypes,
      selectedStaff: _selectedStaff,
      selectedStatuses: _selectedStatuses,
      onEventTypesChanged: (types) =>
          setState(() => _selectedEventTypes = types),
      onStaffChanged: (staff) => setState(() => _selectedStaff = staff),
      onStatusesChanged: (statuses) =>
          setState(() => _selectedStatuses = statuses),
      onClearAll: _clearAllFilters,
      onApply: _applyFilters,
    );
  }

  // Event handlers
  void _goToPreviousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  void _goToToday() {
    setState(() {
      _currentDate = DateTime.now();
      _selectedDate = DateTime.now();
    });
  }

  void _onViewChanged(String view) {
    setState(() {
      _selectedView = view;
    });
  }

  void _onDateTapped(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _onEventTap(DateTime date, Map<String, dynamic> event) {
    _onEventSelected(event);
  }

  void _onEventSelected(Map<String, dynamic> event) {
    // Navigate to event details or show details dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event['clientName'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ইভেন্ট: ${_getEventTypeText(event['eventType'] as String)}'),
            Text('সময়: ${event['timeSlot']}'),
            Text('স্থান: ${event['venue']}'),
            Text('স্ট্যাটাস: ${_getStatusText(event['status'] as String)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বন্ধ করুন'),
          ),
        ],
      ),
    );
  }

  void _onEventLongPress(DateTime date, Map<String, dynamic> event) {
    setState(() {
      _selectedEvent = event;
      _showContextMenu = true;
    });
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);
  }

  void _createNewBooking() {
    Navigator.pushNamed(context, '/event-booking-management-screen');
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'dashboard':
        Navigator.pushNamed(context, '/dashboard-screen');
        break;
      case 'booking':
        Navigator.pushNamed(context, '/event-booking-management-screen');
        break;
      case 'staff':
        Navigator.pushNamed(context, '/staff-management-screen');
        break;
      case 'inventory':
        Navigator.pushNamed(context, '/inventory-management-screen');
        break;
    }
  }

  // Context menu actions
  void _editEvent() {
    setState(() => _showContextMenu = false);
    Navigator.pushNamed(context, '/event-booking-management-screen');
  }

  void _duplicateEvent() {
    setState(() => _showContextMenu = false);
    // Implement duplicate functionality
  }

  void _cancelEvent() {
    setState(() => _showContextMenu = false);
    // Implement cancel functionality
  }

  void _viewEventDetails() {
    setState(() => _showContextMenu = false);
    _onEventSelected(_selectedEvent!);
  }

  // Filter methods
  void _clearAllFilters() {
    setState(() {
      _selectedEventTypes.clear();
      _selectedStaff.clear();
      _selectedStatuses.clear();
    });
  }

  void _applyFilters() {
    setState(() => _showFilters = false);
  }

  // Helper methods
  List<Map<String, dynamic>> _getFilteredEvents() {
    return _events.where((event) {
      if (_selectedEventTypes.isNotEmpty &&
          !_selectedEventTypes.contains(event['eventType'])) {
        return false;
      }

      if (_selectedStatuses.isNotEmpty &&
          !_selectedStatuses.contains(event['status'])) {
        return false;
      }

      if (_selectedStaff.isNotEmpty) {
        final eventStaff = event['assignedStaff'] as List;
        final hasSelectedStaff =
            _selectedStaff.any((staff) => eventStaff.contains(staff));
        if (!hasSelectedStaff) return false;
      }

      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _getEventsForDate(DateTime date) {
    return _getFilteredEvents().where((event) {
      final eventDate = event['date'] as DateTime;
      return eventDate.year == date.year &&
          eventDate.month == date.month &&
          eventDate.day == date.day;
    }).toList();
  }

  String _getBengaliMonth(DateTime date) {
    const months = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getEventTypeText(String eventType) {
    switch (eventType) {
      case 'wedding':
        return 'বিবাহ অনুষ্ঠান';
      case 'birthday':
        return 'জন্মদিন';
      case 'corporate':
        return 'কর্পোরেট ইভেন্ট';
      case 'anniversary':
        return 'বার্ষিকী';
      default:
        return 'অন্যান্য';
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'নিশ্চিত';
      case 'pending':
        return 'অপেক্ষমাণ';
      case 'conflict':
        return 'সংঘর্ষ';
      default:
        return 'অজানা';
    }
  }
}
