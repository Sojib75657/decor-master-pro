import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_feed_widget.dart';
import './widgets/business_header_widget.dart';
import './widgets/calendar_widget.dart';
import './widgets/metric_card_widget.dart';
import './widgets/quick_action_card_widget.dart';
import './widgets/status_bar_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  DateTime _lastUpdated = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _refreshData();
        _startAutoRefresh();
      }
    });
  }

  Future<void> _refreshData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _lastUpdated = DateTime.now();
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ডেটা আপডেট হয়েছে'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showQuickActionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'দ্রুত কার্যক্রম',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                mainAxisSpacing: 3.h,
                crossAxisSpacing: 4.w,
                childAspectRatio: 1.2,
                children: [
                  _buildBottomSheetAction('নতুন বুকিং', 'add_circle', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, '/event-booking-management-screen');
                  }),
                  _buildBottomSheetAction('স্টাফ যোগ করুন', 'person_add', () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/staff-management-screen');
                  }),
                  _buildBottomSheetAction('ইনভেন্টরি যোগ করুন', 'inventory_2',
                      () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, '/inventory-management-screen');
                  }),
                  _buildBottomSheetAction('ক্যালেন্ডার দেখুন', 'calendar_today',
                      () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, '/calendar-and-scheduling-screen');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetAction(
      String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showMetricDetails(String title, String value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '$title বিস্তারিত',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'বর্তমান মান: $value',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'গত সপ্তাহের তুলনায় ১২% বৃদ্ধি',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'শেষ আপডেট: ${_formatTime(_lastUpdated)}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'বন্ধ করুন',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      drawer: _buildNavigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickActionsBottomSheet,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          size: 6.w,
        ),
      ),
      body: Column(
        children: [
          const StatusBarWidget(),
          BusinessHeaderWidget(
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDashboardTab(),
                _buildPlaceholderTab('বুকিং'),
                _buildPlaceholderTab('স্টাফ'),
                _buildPlaceholderTab('ইনভেন্টরি'),
                _buildPlaceholderTab('রিপোর্ট'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'ড্যাশবোর্ড'),
          Tab(text: 'বুকিং'),
          Tab(text: 'স্টাফ'),
          Tab(text: 'ইনভেন্টরি'),
          Tab(text: 'রিপোর্ট'),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            _buildMetricsSection(),
            SizedBox(height: 2.h),
            _buildQuickActionsSection(),
            SizedBox(height: 2.h),
            CalendarWidget(
              onDateTap: (date) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '${date.day}/${date.month}/${date.year} এর বুকিং দেখানো হচ্ছে'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const ActivityFeedWidget(),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      children: [
        MetricCardWidget(
          title: 'আজকের বুকিং',
          value: '৮',
          subtitle: 'গতকালের চেয়ে +২',
          iconName: 'event',
          onTap: () =>
              Navigator.pushNamed(context, '/event-booking-management-screen'),
          onLongPress: () => _showMetricDetails('আজকের বুকিং', '৮'),
        ),
        MetricCardWidget(
          title: 'অপেক্ষমাণ পেমেন্ট',
          value: '৳৪৫,০০০',
          subtitle: 'মোট ৫টি বুকিং',
          iconName: 'payment',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('পেমেন্ট সেকশনে যাচ্ছি...')),
            );
          },
          onLongPress: () => _showMetricDetails('অপেক্ষমাণ পেমেন্ট', '৳৪৫,০০০'),
        ),
        MetricCardWidget(
          title: 'উপলব্ধ স্টাফ',
          value: '১২',
          subtitle: 'মোট ১৫ জনের মধ্যে',
          iconName: 'people',
          onTap: () => Navigator.pushNamed(context, '/staff-management-screen'),
          onLongPress: () => _showMetricDetails('উপলব্ধ স্টাফ', '১২'),
        ),
        MetricCardWidget(
          title: 'মাসিক আয়',
          value: '৳২,৮৫,০০০',
          subtitle: 'গত মাসের চেয়ে +১৮%',
          iconName: 'trending_up',
          backgroundColor:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.05),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('রিপোর্ট সেকশনে যাচ্ছি...')),
            );
          },
          onLongPress: () => _showMetricDetails('মাসিক আয়', '৳২,৮৫,০০০'),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'দ্রুত কার্যক্রম',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              QuickActionCardWidget(
                title: 'নতুন বুকিং',
                iconName: 'add_circle',
                onTap: () => Navigator.pushNamed(
                    context, '/event-booking-management-screen'),
              ),
              QuickActionCardWidget(
                title: 'পেমেন্ট গ্রহণ',
                iconName: 'payment',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('পেমেন্ট গ্রহণ করা হচ্ছে...')),
                  );
                },
              ),
              QuickActionCardWidget(
                title: 'ইনভয়েস তৈরি',
                iconName: 'receipt',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ইনভয়েস তৈরি করা হচ্ছে...')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'construction',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 3.h),
          Text(
            '$tabName সেকশন',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'শীঘ্রই আসছে...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'ডি',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'ডেকোমাস্টার',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'শেষ আপডেট: ${_formatTime(_lastUpdated)}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem('সেটিংস', 'settings', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('সেটিংস খোলা হচ্ছে...')),
                  );
                }),
                _buildDrawerItem('ব্যাকআপ', 'backup', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ব্যাকআপ শুরু হচ্ছে...')),
                  );
                }),
                _buildDrawerItem('সাহায্য', 'help', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('সাহায্য পেজ খোলা হচ্ছে...')),
                  );
                }),
                const Divider(),
                _buildDrawerItem('লগ আউট', 'logout', () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login-screen');
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.onSurface,
        size: 5.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
