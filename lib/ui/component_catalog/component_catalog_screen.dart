import 'package:flutter/material.dart';
import 'package:flux_state/core/utils/formatters.dart';
import 'package:flux_state/domain/models/component.dart';
import 'package:flux_state/domain/models/component_category.dart';
import 'package:flux_state/repository_provider.dart';
import 'package:flux_state/theme/app_colors.dart';
import 'package:flux_state/theme/app_typography.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_screen.dart';
import 'package:flux_state/ui/component_catalog/add_edit_component_viewmodel.dart';
import 'package:flux_state/ui/component_catalog/component_catalog_viewmodel.dart';

class ComponentCatalogScreen extends StatefulWidget {
  const ComponentCatalogScreen({super.key, required this.viewModel});

  final ComponentCatalogViewModel viewModel;

  @override
  State<ComponentCatalogScreen> createState() => _ComponentCatalogScreenState();
}

class _ComponentCatalogScreenState extends State<ComponentCatalogScreen> {
  late ComponentCategory? _selectedCat = widget.viewModel.initialCategory;
  final _searchCtrl = TextEditingController();
  String _searchQ = '';

  @override
  void initState() {
    super.initState();

    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    void reload() async {
      await widget.viewModel.load();
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('flux_state'),
        ),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: _CategoryFilterSidebar(
              selected: _selectedCat,
              onCategoryChanged: (c) => setState(() => _selectedCat = c),
            ),
          ),
          Container(width: 1, color: colors.surfaceContainerLow),
          Expanded(
            child: Column(
              children: [
                _SearchBar(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQ = v),
                  onRefreshRequested: reload,
                  selectedCat: _selectedCat,
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (context, child) {
                      final components = widget.viewModel.components(
                        _selectedCat,
                        _searchQ,
                      );
                      if (components.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return _ComponentList(
                          components: components,
                          selectedCat: _selectedCat,
                          onRefreshRequested: reload,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterSidebar extends StatelessWidget {
  const _CategoryFilterSidebar({
    required this.selected,
    required this.onCategoryChanged,
  });

  final ComponentCategory? selected;
  final ValueChanged<ComponentCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      color: colors.surfaceContainerLow,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        children: [
          const _SidebarLabel('CATEGORIES'),
          const SizedBox(height: 8),
          _CategoryItem(
            icon: Icons.apps_rounded,
            label: 'ALL PARTS',
            selected: selected == null,
            onTap: () => onCategoryChanged(null),
          ),
          const SizedBox(height: 2),
          const _SidebarLabel('ELECTRONIC', indent: 4, topPad: 12),
          ..._electronic.map(
            (cat) => _CategoryItem(
              icon: cat.icon,
              label: cat.displayName.toUpperCase(),
              color: cat.color,
              selected: selected == cat,
              onTap: () => onCategoryChanged(cat),
            ),
          ),
        ],
      ),
    );
  }

  static final _electronic = ComponentCategory.values
      .where((c) => !c.isHardware)
      .toList();
}

class _SidebarLabel extends StatelessWidget {
  const _SidebarLabel(this.text, {this.indent = 0, this.topPad = 0});

  final String text;
  final double indent;
  final double topPad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: indent, top: topPad, bottom: 4),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.1),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? colors.primaryContainer.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? colors.primary
                  : (color ?? colors.onSurfaceVariant),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: typography.labelMedium?.copyWith(
                  color: selected ? colors.primary : colors.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> navigateToAddEditWithRefresh(
  BuildContext context,
  VoidCallback onRefreshRequested, {
  ComponentCategory? selectedCat,
  String? componentId,
}) async {
  final bool? isDataUpdated = await Navigator.push(
    context,
    MaterialPageRoute<bool>(
      builder: (context) => AddEditComponentScreen(
        viewModel: AddEditComponentViewModel(
          inventoryRepository: RepositoryProvider.of(context),
          initialCategory: selectedCat,
          componentId: componentId,
        ),
      ),
    ),
  );
  if (isDataUpdated == true) {
    onRefreshRequested();
  }
}

class _ComponentList extends StatelessWidget {
  const _ComponentList({
    required this.components,
    required this.onRefreshRequested,
    this.selectedCat,
  });

  final List<Component> components;
  final VoidCallback onRefreshRequested;
  final ComponentCategory? selectedCat;

  @override
  Widget build(BuildContext context) {
    if (components.isEmpty) {
      return _EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No components found',
        subtitle: 'Try adjusting your filters or add a new part',
        action: TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Component'),
          onPressed: () {
            navigateToAddEditWithRefresh(
              context,
              onRefreshRequested,
              selectedCat: selectedCat,
            );
          },
        ),
      );
    }

    return GridView.count(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      crossAxisCount: 4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: components
          .map(
            (c) => _ComponentCard(
              component: c,
              onTap: () {
                navigateToAddEditWithRefresh(
                  context,
                  onRefreshRequested,
                  componentId: c.id,
                  selectedCat: selectedCat,
                );
              },
            ),
          )
          .toList(),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  const _ComponentCard({required this.component, this.onTap});

  final Component component;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroArea(component: component),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          component.display(),
                          style: typography.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('STOCK', style: typography.labelSmall),
                          Text(
                            Formatters.quantity(component.quantity),
                            style: AppTypography.stockNumber.copyWith(
                              color: _stockColor,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get _stockColor => switch (component.stockStatus) {
    StockStatus.outOfStock => AppColors.error,
    StockStatus.lowStock => AppColors.tertiary,
    StockStatus.inStock => AppColors.onSurface,
  };
}

class _HeroArea extends StatelessWidget {
  const _HeroArea({required this.component});

  final Component component;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;

    return SizedBox(
      height: 130,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.cardHeroGradient,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    component.category.color.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          Center(
            child: Icon(
              component.category.icon,
              size: 76,
              color: component.category.color.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 12,
            child: Row(
              children: [
                Icon(
                  component.category.icon,
                  size: 12,
                  color: component.category.color.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  component.category.singularName.toUpperCase(),
                  style: typography.labelSmall?.copyWith(
                    color: component.category.color.withValues(alpha: 0.7),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: colors.onSurfaceVariant.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: typography.titleMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: typography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 28), action!],
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onRefreshRequested,
    this.selectedCat,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onRefreshRequested;
  final ComponentCategory? selectedCat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: typography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Filter by name, value, or ...',
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        color: colors.onSurfaceVariant,
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _NewPartBtn(
            onRefreshRequested: onRefreshRequested,
            selectedCat: selectedCat,
          ),
        ],
      ),
    );
  }
}

class _NewPartBtn extends StatelessWidget {
  const _NewPartBtn({required this.onRefreshRequested, this.selectedCat});

  final VoidCallback onRefreshRequested;
  final ComponentCategory? selectedCat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typography = theme.textTheme;
    final colors = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        navigateToAddEditWithRefresh(
          context,
          onRefreshRequested,
          selectedCat: selectedCat,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: colors.onPrimaryContainer),
            const SizedBox(width: 6),
            Text(
              'NEW PART',
              style: typography.labelMedium?.copyWith(
                color: colors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
