import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/time_control.dart';

class CustomTimePicker extends StatefulWidget {
  final void Function(TimeControl timeControl) onConfirm;

  const CustomTimePicker({super.key, required this.onConfirm});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  int _minutes = 5;
  int _increment = 0;

  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _incrementController;

  @override
  void initState() {
    super.initState();
    _minutesController = FixedExtentScrollController(initialItem: _minutes - 1);
    _incrementController = FixedExtentScrollController(initialItem: _increment);
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _incrementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Custom Time Control',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),

          // Scroll wheels
          Row(
            children: [
              // Minutes wheel
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Minutes',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        controller: _minutesController,
                        itemExtent: 44,
                        diameterRatio: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() => _minutes = index + 1);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index < 0 || index >= 180) return null;
                            final isSelected = index == _minutes - 1;
                            return Center(
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.robotoMono(
                                  fontSize: isSelected ? 28 : 20,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface.withOpacity(
                                          0.4,
                                        ),
                                ),
                              ),
                            );
                          },
                          childCount: 180,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  '+',
                  style: GoogleFonts.robotoMono(
                    fontSize: 32,
                    fontWeight: FontWeight.w300,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),

              // Increment wheel
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Increment',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        controller: _incrementController,
                        itemExtent: 44,
                        diameterRatio: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() => _increment = index);
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index < 0 || index >= 60) return null;
                            final isSelected = index == _increment;
                            return Center(
                              child: Text(
                                '$index',
                                style: GoogleFonts.robotoMono(
                                  fontSize: isSelected ? 28 : 20,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface.withOpacity(
                                          0.4,
                                        ),
                                ),
                              ),
                            );
                          },
                          childCount: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Preview
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$_minutes + $_increment',
              style: GoogleFonts.robotoMono(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Confirm button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final tc = TimeControl(
                  id: 'custom_${_minutes}_$_increment',
                  name: '$_minutes+$_increment',
                  durationMinutes: _minutes,
                  incrementSeconds: _increment,
                  category: 'Custom',
                  isCustom: true,
                );
                widget.onConfirm(tc);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Create Time Control',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
