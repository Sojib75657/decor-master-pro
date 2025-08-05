import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddItemBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddItem;

  const AddItemBottomSheet({
    super.key,
    required this.onAddItem,
  });

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _rentalRateController = TextEditingController();
  final _barcodeController = TextEditingController();

  String _selectedCategory = 'Flowers';
  XFile? _selectedImage;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _showCamera = false;

  final List<Map<String, String>> _categories = [
    {'value': 'Flowers', 'label': 'ফুল'},
    {'value': 'Lights', 'label': 'লাইট'},
    {'value': 'Chairs', 'label': 'চেয়ার'},
    {'value': 'Stage', 'label': 'স্টেজ'},
    {'value': 'Sound', 'label': 'সাউন্ড'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _rentalRateController.dispose();
    _barcodeController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras!.isEmpty) return;

      final camera = kIsWeb
          ? _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras!.first,
            )
          : _cameras!.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras!.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _selectedImage = photo;
        _showCamera = false;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Gallery picker error: $e');
    }
  }

  void _scanBarcode() {
    // Simulated barcode scanning - in real app would use barcode_scan2 package
    setState(() {
      _barcodeController.text = 'ITEM${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newItem = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': _nameController.text,
        'category': _selectedCategory,
        'stock': int.parse(_stockController.text),
        'rentalRate': double.parse(_rentalRateController.text),
        'barcode': _barcodeController.text,
        'status': 'Available',
        'image': _selectedImage?.path ??
            'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg',
        'addedDate': DateTime.now().toIso8601String(),
      };

      widget.onAddItem(newItem);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
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

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'নতুন আইটেম যোগ করুন',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
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

          // Form content
          Expanded(
            child: _showCamera && _isCameraInitialized
                ? _buildCameraView()
                : _buildFormView(),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return Column(
      children: [
        Expanded(
          child: _cameraController != null &&
                  _cameraController!.value.isInitialized
              ? CameraPreview(_cameraController!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _showCamera = false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                  foregroundColor: AppTheme.textPrimaryLight,
                ),
                child: const Text('বাতিল'),
              ),
              FloatingActionButton(
                onPressed: _capturePhoto,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                child: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: Colors.white,
                  size: 8.w,
                ),
              ),
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: const Text('গ্যালারি'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Container(
              width: double.infinity,
              height: 25.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.getBorderColor(true)),
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(
                              _selectedImage!.path,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _selectedImage!.path,
                              fit: BoxFit.cover,
                            ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'add_a_photo',
                          color: AppTheme.textSecondaryLight,
                          size: 12.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'ছবি যোগ করুন',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
            ),

            SizedBox(height: 2.h),

            // Photo buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _showCamera = true),
                    icon: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                    label: const Text('ক্যামেরা'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                    label: const Text('গ্যালারি'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Item name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'আইটেমের নাম *',
                hintText: 'যেমন: লাল গোলাপ, LED লাইট',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'আইটেমের নাম প্রয়োজন';
                }
                return null;
              },
            ),

            SizedBox(height: 2.h),

            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'ক্যাটেগরি *',
              ),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['value'],
                  child: Text(category['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),

            SizedBox(height: 2.h),

            // Stock and rental rate
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'স্টক পরিমাণ *',
                      hintText: '০',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'স্টক পরিমাণ প্রয়োজন';
                      }
                      if (int.tryParse(value) == null) {
                        return 'সংখ্যা লিখুন';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: TextFormField(
                    controller: _rentalRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ভাড়ার হার (৳) *',
                      hintText: '০.০০',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ভাড়ার হার প্রয়োজন';
                      }
                      if (double.tryParse(value) == null) {
                        return 'সংখ্যা লিখুন';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Barcode section
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _barcodeController,
                    decoration: const InputDecoration(
                      labelText: 'বারকোড (ঐচ্ছিক)',
                      hintText: 'বারকোড স্ক্যান করুন বা টাইপ করুন',
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                IconButton(
                  onPressed: _scanBarcode,
                  icon: CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('আইটেম যোগ করুন'),
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
