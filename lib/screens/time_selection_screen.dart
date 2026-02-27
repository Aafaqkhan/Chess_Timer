import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../controllers/timer_controller.dart';
import '../models/time_control.dart';
import '../utils/constants.dart';
import '../components/time_control_chip.dart';
import '../components/custom_time_picker.dart';
import '../services/storage_service.dart';

class TimeSelectionScreen extends StatefulWidget {
  const TimeSelectionScreen({super.key});

  @override
  State<TimeSelectionScreen> createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TimerController _timerController = Get.find<TimerController>();

  final List<String> _categories = [
    AppConstants.categoryBullet,
    AppConstants.categoryBlitz,
    AppConstants.categoryRapid,
    AppConstants.categoryClassical,
    AppConstants.categoryCustom,
  ];

  // User-created custom time controls (session-only for now)
  final List<TimeControl> _customTimeControls = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _customTimeControls.addAll(
      Get.find<StorageService>().loadCustomTimeControls(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TimeControl> _getFilteredControls(String category) {
    if (category == AppConstants.categoryCustom) {
      return _customTimeControls;
    }
    return AppConstants.defaultTimeControls
        .where((tc) => tc.category == category)
        .toList();
  }

  void _openCustomPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomTimePicker(
        onConfirm: (tc) {
          setState(() {
            _customTimeControls.add(tc);
            Get.find<StorageService>().saveCustomTimeControls(
              _customTimeControls,
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Select Time Control',
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.5),
          labelStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          tabAlignment: TabAlignment.start,
          tabs: _categories.map((c) => Tab(text: c)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) {
          final controls = _getFilteredControls(category);

          if (controls.isEmpty && category == AppConstants.categoryCustom) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.clock,
                    size: 56,
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No custom time controls yet',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create one',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: category == AppConstants.categoryCustom ? 2 : 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: controls.length,
              itemBuilder: (context, index) {
                final control = controls[index];
                return Obx(
                  () => TimeControlChip(
                    timeControl: control,
                    isSelected:
                        _timerController.currentTimeControl.value.id ==
                        control.id,
                    onTap: () {
                      _timerController.setTimeControl(control);
                      Get.back();
                    },
                    onLongPress: category == AppConstants.categoryCustom
                        ? () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Delete Time Control',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to delete this custom time control?',
                                  style: GoogleFonts.outfit(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.outfit(),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _customTimeControls.remove(control);
                                        Get.find<StorageService>()
                                            .saveCustomTimeControls(
                                              _customTimeControls,
                                            );
                                      });
                                      Get.back(); // close dialog

                                      // If the deleted control was the currently selected one,
                                      // we might want to revert to a default to avoid errors
                                      if (_timerController
                                              .currentTimeControl
                                              .value
                                              .id ==
                                          control.id) {
                                        _timerController.setTimeControl(
                                          AppConstants
                                              .defaultTimeControls
                                              .first,
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Delete',
                                      style: GoogleFonts.outfit(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        : null,
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCustomPicker,
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}
