import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_item_bottom_sheet.dart';
import './widgets/category_filter_chip.dart';
import './widgets/inventory_item_card.dart';
import './widgets/item_detail_bottom_sheet.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  List<int> _selectedItems = [];
  bool _isMultiSelectMode = false;
  bool _isRefreshing = false;

  final List<String> _categories = [
    'All',
    'Flowers',
    'Lights',
    'Chairs',
    'Stage',
    'Sound'
  ];

  final Map<String, String> _categoryLabels = {
    'All': 'সব',
    'Flowers': 'ফুল',
    'Lights': 'লাইট',
    'Chairs': 'চেয়ার',
    'Stage': 'স্টেজ',
    'Sound': 'সাউন্ড',
  };

  List<Map<String, dynamic>> _inventoryItems = [
    {
      'id': 1,
      'name': 'লাল গোলাপের তোড়া',
      'category': 'Flowers',
      'stock': 25,
      'rentalRate': 150.0,
      'status': 'Available',
      'image':
          'https://images.pexels.com/photos/56866/garden-rose-red-pink-56866.jpeg',
      'barcode': 'FLOWER001',
      'addedDate': '2025-07-20T10:30:00Z',
    },
    {
      'id': 2,
      'name': 'LED স্ট্রিং লাইট',
      'category': 'Lights',
      'stock': 3,
      'rentalRate': 300.0,
      'status': 'Available',
      'image':
          'https://images.pexels.com/photos/1303081/pexels-photo-1303081.jpeg',
      'barcode': 'LIGHT001',
      'addedDate': '2025-07-19T14:15:00Z',
    },
    {
      'id': 3,
      'name': 'সাদা প্লাস্টিক চেয়ার',
      'category': 'Chairs',
      'stock': 50,
      'rentalRate': 25.0,
      'status': 'Available',
      'image':
          'https://images.pexels.com/photos/116910/pexels-photo-116910.jpeg',
      'barcode': 'CHAIR001',
      'addedDate': '2025-07-18T09:00:00Z',
    },
    {
      'id': 4,
      'name': 'ডেকোরেটিভ স্টেজ ব্যাকড্রপ',
      'category': 'Stage',
      'stock': 8,
      'rentalRate': 800.0,
      'status': 'Used',
      'image':
          'https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg',
      'barcode': 'STAGE001',
      'addedDate': '2025-07-17T16:45:00Z',
    },
    {
      'id': 5,
      'name': 'পোর্টেবল সাউন্ড সিস্টেম',
      'category': 'Sound',
      'stock': 2,
      'rentalRate': 1200.0,
      'status': 'Maintenance',
      'image':
          'https://images.pexels.com/photos/164938/pexels-photo-164938.jpeg',
      'barcode': 'SOUND001',
      'addedDate': '2025-07-16T11:20:00Z',
    },
    {
      'id': 6,
      'name': 'সাদা জুঁই ফুলের মালা',
      'category': 'Flowers',
      'stock': 15,
      'rentalRate': 200.0,
      'status': 'Available',
      'image':
          'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
      'barcode': 'FLOWER002',
      'addedDate': '2025-07-15T13:30:00Z',
    },
    {
      'id': 7,
      'name': 'কালারফুল LED বাল্ব',
      'category': 'Lights',
      'stock': 1,
      'rentalRate': 450.0,
      'status': 'Available',
      'image':
          'https://images.pexels.com/photos/1036936/pexels-photo-1036936.jpeg',
      'barcode': 'LIGHT002',
      'addedDate': '2025-07-14T08:15:00Z',
    },
    {
      'id': 8,
      'name': 'গোল্ডেন চেয়ার কভার',
      'category': 'Chairs',
      'stock': 30,
      'rentalRate': 35.0,
      'status': 'Available',
      'image':
          'https://images.pexels.com/photos/1395967/pexels-photo-1395967.jpeg',
      'barcode': 'CHAIR002',
      'addedDate': '2025-07-13T15:45:00Z',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredItems {
    List<Map<String, dynamic>> filtered = _inventoryItems;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((item) => item['category'] == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((item) {
        final name = (item['name'] as String).toLowerCase();
        final category = (item['category'] as String).toLowerCase();
        return name.contains(query) || category.contains(query);
      }).toList();
    }

    return filtered;
  }

  Future<void> _refreshInventory() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate haptic feedback
    HapticFeedback.lightImpact();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate data refresh
    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ইনভেন্টরি আপডেট হয়েছে'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }

      if (_selectedItems.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _enterMultiSelectMode(int itemId) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedItems.add(itemId);
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedItems.clear();
    });
  }

  void _showAddItemBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddItemBottomSheet(
        onAddItem: (newItem) {
          setState(() {
            _inventoryItems.add(newItem);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('নতুন আইটেম যোগ করা হয়েছে'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  void _showItemDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ItemDetailBottomSheet(
        item: item,
        onEdit: () {
          Navigator.pop(context);
          _showEditItemDialog(item);
        },
        onDelete: () {
          Navigator.pop(context);
          _showDeleteConfirmation(item);
        },
      ),
    );
  }

  void _showEditItemDialog(Map<String, dynamic> item) {
    final nameController = TextEditingController(text: item['name']);
    final stockController =
        TextEditingController(text: item['stock'].toString());
    final rateController =
        TextEditingController(text: item['rentalRate'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('আইটেম সম্পাদনা'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'নাম'),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'স্টক'),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ভাড়ার হার'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index =
                    _inventoryItems.indexWhere((i) => i['id'] == item['id']);
                if (index != -1) {
                  _inventoryItems[index]['name'] = nameController.text;
                  _inventoryItems[index]['stock'] =
                      int.tryParse(stockController.text) ?? 0;
                  _inventoryItems[index]['rentalRate'] =
                      double.tryParse(rateController.text) ?? 0.0;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('আইটেম আপডেট হয়েছে')),
              );
            },
            child: const Text('সংরক্ষণ'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('নিশ্চিত করুন'),
        content: Text('আপনি কি "${item['name']}" আইটেমটি মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _inventoryItems.removeWhere((i) => i['id'] == item['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('আইটেম মুছে ফেলা হয়েছে')),
              );
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.errorLight),
            child: const Text('মুছুন'),
          ),
        ],
      ),
    );
  }

  void _handleRightSwipe(Map<String, dynamic> item) {
    _showEditItemDialog(item);
  }

  void _handleLeftSwipe(Map<String, dynamic> item) {
    final newStatus = item['status'] == 'Available' ? 'Used' : 'Available';
    setState(() {
      final index = _inventoryItems.indexWhere((i) => i['id'] == item['id']);
      if (index != -1) {
        _inventoryItems[index]['status'] = newStatus;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'স্ট্যাটাস পরিবর্তন: ${newStatus == 'Available' ? 'উপলব্ধ' : 'ব্যবহৃত'}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBulkOperationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_selectedItems.length}টি আইটেম নির্বাচিত'),
        content: const Text('আপনি কী করতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateSelectedQuantities();
            },
            child: const Text('পরিমাণ আপডেট'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _changeSelectedRates();
            },
            child: const Text('হার পরিবর্তন'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportSelectedItems();
            },
            child: const Text('রিপোর্ট এক্সপোর্ট'),
          ),
        ],
      ),
    );
  }

  void _updateSelectedQuantities() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('পরিমাণ আপডেট'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'নতুন স্টক পরিমাণ',
            hintText: 'সংখ্যা লিখুন',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(controller.text);
              if (newStock != null) {
                setState(() {
                  for (final itemId in _selectedItems) {
                    final index =
                        _inventoryItems.indexWhere((i) => i['id'] == itemId);
                    if (index != -1) {
                      _inventoryItems[index]['stock'] = newStock;
                    }
                  }
                });
                _exitMultiSelectMode();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('স্টক আপডেট হয়েছে')),
                );
              }
            },
            child: const Text('আপডেট'),
          ),
        ],
      ),
    );
  }

  void _changeSelectedRates() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('হার পরিবর্তন'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'নতুন ভাড়ার হার (৳)',
            hintText: '০.০০',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              final newRate = double.tryParse(controller.text);
              if (newRate != null) {
                setState(() {
                  for (final itemId in _selectedItems) {
                    final index =
                        _inventoryItems.indexWhere((i) => i['id'] == itemId);
                    if (index != -1) {
                      _inventoryItems[index]['rentalRate'] = newRate;
                    }
                  }
                });
                _exitMultiSelectMode();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('হার আপডেট হয়েছে')),
                );
              }
            },
            child: const Text('পরিবর্তন'),
          ),
        ],
      ),
    );
  }

  void _exportSelectedItems() {
    // Simulate export functionality
    _exitMultiSelectMode();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('রিপোর্ট এক্সপোর্ট করা হচ্ছে...'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('ইনভেন্টরি ম্যানেজমেন্ট'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimaryLight,
            size: 6.w,
          ),
        ),
        actions: [
          if (_isMultiSelectMode) ...[
            IconButton(
              onPressed: _showBulkOperationsDialog,
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.textPrimaryLight,
                size: 6.w,
              ),
            ),
            IconButton(
              onPressed: _exitMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.textPrimaryLight,
                size: 6.w,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                // Show search/filter options
              },
              icon: CustomIconWidget(
                iconName: 'filter_list',
                color: AppTheme.textPrimaryLight,
                size: 6.w,
              ),
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (index) {
            // Handle tab navigation
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/login-screen');
                break;
              case 1:
                Navigator.pushNamed(context, '/dashboard-screen');
                break;
              case 2:
                Navigator.pushNamed(
                    context, '/event-booking-management-screen');
                break;
              case 3:
                // Current screen - do nothing
                break;
              case 4:
                Navigator.pushNamed(context, '/staff-management-screen');
                break;
              case 5:
                Navigator.pushNamed(context, '/calendar-and-scheduling-screen');
                break;
            }
          },
          tabs: const [
            Tab(text: 'লগইন'),
            Tab(text: 'ড্যাশবোর্ড'),
            Tab(text: 'বুকিং'),
            Tab(text: 'ইনভেন্টরি'),
            Tab(text: 'স্টাফ'),
            Tab(text: 'ক্যালেন্ডার'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(4.w),
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'আইটেম বা ক্যাটেগরি খুঁজুন...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondaryLight,
                    size: 5.w,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.textSecondaryLight,
                          size: 5.w,
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // Category filter chips
          Container(
            height: 8.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryFilterChip(
                  category: category,
                  label: _categoryLabels[category]!,
                  isSelected: _selectedCategory == category,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          // Multi-select info bar
          if (_isMultiSelectMode)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              child: Text(
                '${_selectedItems.length}টি আইটেম নির্বাচিত',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Inventory grid
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _refreshInventory,
                    child: GridView.builder(
                      padding: EdgeInsets.all(4.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 3.w,
                        mainAxisSpacing: 3.w,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final isSelected = _selectedItems.contains(item['id']);

                        return InventoryItemCard(
                          item: item,
                          isSelected: isSelected,
                          onTap: () {
                            if (_isMultiSelectMode) {
                              _toggleItemSelection(item['id'] as int);
                            } else {
                              _showItemDetail(item);
                            }
                          },
                          onLongPress: () {
                            if (!_isMultiSelectMode) {
                              HapticFeedback.mediumImpact();
                              _enterMultiSelectMode(item['id'] as int);
                            }
                          },
                          onRightSwipe: () => _handleRightSwipe(item),
                          onLeftSwipe: () => _handleLeftSwipe(item),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _showAddItemBottomSheet,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 6.w,
              ),
              label: const Text('নতুন আইটেম'),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'inventory_2',
            color: AppTheme.textSecondaryLight,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            _selectedCategory == 'All'
                ? 'কোন আইটেম পাওয়া যায়নি'
                : 'এই ক্যাটেগরিতে কোন আইটেম নেই',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          if (_selectedCategory != 'All')
            Text(
              'আইটেম যোগ করুন',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 4.h),
          ElevatedButton.icon(
            onPressed: _showAddItemBottomSheet,
            icon: CustomIconWidget(
              iconName: 'add',
              color: Colors.white,
              size: 5.w,
            ),
            label: const Text('প্রথম আইটেম যোগ করুন'),
          ),
        ],
      ),
    );
  }
}
