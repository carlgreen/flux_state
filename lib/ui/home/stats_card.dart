import 'package:flutter/material.dart';
import 'package:flux_state/theme/app_typography.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final typography = theme.textTheme;

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label.toUpperCase(), style: typography.labelSmall),
                if (icon != null)
                  Icon(
                    icon,
                    size: 18,
                    color: valueColor ?? colors.onSurfaceVariant,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTypography.stockNumber.copyWith(
                color: valueColor ?? colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
