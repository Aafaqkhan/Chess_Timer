import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/time_control.dart';

class TimeControlChip extends StatelessWidget {
  final TimeControl timeControl;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const TimeControlChip({
    super.key,
    required this.timeControl,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          onLongPress: onLongPress,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.brightness == Brightness.dark
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.center, // ✅ center everything
              clipBehavior: Clip.none,
              children: [
                /// CENTERED CONTENT
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // ✅ horizontal center
                    mainAxisAlignment:
                        MainAxisAlignment.center, // ✅ vertical center
                    children: [
                      Text(
                        timeControl.displayFormat,
                        textAlign: TextAlign.center, // ✅ text center
                        style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeControl.category,
                        textAlign: TextAlign.center, // ✅ text center
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔴 DELETE ICON (only for custom controls)
                if (timeControl.isCustom)
                  Positioned(
                    top: -16,
                    right: -22,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () async {
                          onLongPress?.call();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
