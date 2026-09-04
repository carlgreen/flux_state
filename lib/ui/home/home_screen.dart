import 'package:flutter/material.dart';
import 'package:flux_state/core/utils/formatters.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/repository_provider.dart';
import 'package:flux_state/theme/app_colors.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_screen.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_screen.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';
import 'package:flux_state/ui/home/home_viewmodel.dart';
import 'package:flux_state/ui/home/stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DashboardStats> _stats;

  @override
  void initState() {
    super.initState();
    _stats = widget.viewModel.stats;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LAB_DASHBOARD', style: typography.displayLarge),
                const SizedBox(height: 20),
                _NewPartButton(
                  onPressed: () async {
                    final bool? isDataUpdated = await Navigator.push(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (context) => AddEditComponentScreen(
                          viewModel: AddEditComponentViewModel(
                            inventoryRepository: RepositoryProvider.of(context),
                            initialCategory: null,
                          ),
                        ),
                      ),
                    );
                    if (isDataUpdated == true) {
                      setState(() {
                        _stats = widget.viewModel.stats;
                      });
                    }
                  },
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),

        FutureBuilder(
          future: _stats,
          builder: (context, snapshot) {
            final stats = snapshot.data;
            final String? totalTypes = stats != null
                ? Formatters.quantity(stats.totalTypes)
                : null;
            final String? totalUnits = stats != null
                ? Formatters.quantity(stats.totalUnits)
                : null;
            final String? lowStockCount = stats != null
                ? Formatters.quantity(stats.lowStockCount)
                : null;
            final Color? lowStockColour = (stats?.lowStockCount ?? 0) > 0
                ? colors.tertiary
                : null;
            final String? outOfStockCount = stats != null
                ? Formatters.quantity(stats.outOfStockCount)
                : null;
            final Color? outOfStockColour = (stats?.outOfStockCount ?? 0) > 0
                ? colors.error
                : null;
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        label: 'Component_Types',
                        value: totalTypes,
                        icon: Icons.category_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        label: 'Total_Units',
                        value: totalUnits,
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        label: 'Low_Stock',
                        value: lowStockCount,
                        icon: Icons.warning_amber_rounded,
                        valueColor: lowStockColour,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatsCard(
                        label: 'Out_of_Stock',
                        value: outOfStockCount,
                        icon: Icons.error_outline_rounded,
                        valueColor: outOfStockColour,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'COMPONENT_CATEGORIES',
                  style: typography.labelSmall?.copyWith(
                    letterSpacing: 0.12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (context) => ComponentCatalogScreen(
                          viewModel: ComponentCatalogViewModel(
                            inventoryRepository: RepositoryProvider.of(context),
                            //   initialCategory: null,
                          ),
                        ),
                      ),
                    ),
                  },
                  child: Text(
                    'VIEW ALL',
                    style: typography.labelSmall?.copyWith(
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(32, 10, 32, 0),
          sliver: FutureBuilder(
            future: _stats,
            builder: (context, snapshot) {
              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate((context, i) {
                  final cat = ComponentCategory.values[i];
                  return _CategoryGridCell(
                    category: cat,
                    // count: stats.countByCategory[cat] ?? 0,
                    count: snapshot.data == null
                        ? null
                        : snapshot.data!.countByCategory[cat] ?? 0,
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute<bool>(
                          builder: (context) => ComponentCatalogScreen(
                            viewModel: ComponentCatalogViewModel(
                              inventoryRepository: RepositoryProvider.of(
                                context,
                              ),
                              initialCategory: cat,
                            ),
                          ),
                        ),
                      ),
                    },
                  );
                }, childCount: ComponentCategory.values.length),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NewPartButton extends StatelessWidget {
  const _NewPartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: colors.onPrimaryContainer, size: 18),
            const SizedBox(width: 8),
            Text(
              'NEW_COMPONENT',
              style: typography.labelLarge?.copyWith(
                color: colors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGridCell extends StatelessWidget {
  const _CategoryGridCell({
    required this.category,
    required this.count,
    this.onTap,
  });

  final ComponentCategory category;
  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
                Icon(category.icon, color: category.color, size: 22),
                if (count == null)
                  SizedBox.square(
                    dimension: typography.labelLarge?.fontSize,
                    child: const CircularProgressIndicator(strokeWidth: 4.0),
                  ),
                if (count != null)
                  Text(
                    Formatters.quantity(count!),
                    style: typography.labelLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              category.displayName.toUpperCase(),
              style: typography.labelMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(category.groupLabel, style: typography.labelSmall),
          ],
        ),
      ),
    );
  }
}
