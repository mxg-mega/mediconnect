import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mediconnect/core/constants/assets.dart';
import 'package:mediconnect/core/constants/text_styles.dart';
import 'package:mediconnect/core/theme/app_theme.dart';
import 'package:mediconnect/core/utils/figma_scale_utils.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/providers/inventory_provider.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/inventory_filter_bottom_sheet.dart';
import 'package:mediconnect/features/pharmacist_app/presentation/inventory/widgets/inventory_sort_component.dart';

class InventorySearchBar extends ConsumerStatefulWidget {
  const InventorySearchBar({super.key});

  @override
  ConsumerState<InventorySearchBar> createState() => _InventorySearchBarState();
}

class _InventorySearchBarState extends ConsumerState<InventorySearchBar> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _sortOverlay;

  void _toggleSortOverlay() {
    if (_sortOverlay == null) {
      _sortOverlay = _createSortOverlay();
      Overlay.of(context).insert(_sortOverlay!);
    } else {
      _removeSortOverlay();
    }
  }

  void _removeSortOverlay() {
    _sortOverlay?.remove();
    _sortOverlay = null;
  }

  OverlayEntry _createSortOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _removeSortOverlay,
            behavior: HitTestBehavior.translucent,
            child: Container(),
          ),
          Positioned(
            width: context.figmaWidth(150),
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(size.width - context.figmaWidth(150), size.height + 5),
              child: Material(
                elevation: 0,
                color: Colors.transparent,
                child: InventorySortComponent(
                  onSelected: _removeSortOverlay,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeSortOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.colors(context);
    final sortBy = ref.watch(inventoryProvider.select((s) => s.sortBy));

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.figmaWidth(16)),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  controller: _controller,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SvgPicture.asset(
                      AppIcons.search,
                      width: 20,
                      colorFilter: ColorFilter.mode(theme.neutral.secondaryText, BlendMode.srcIn),
                    ),
                  ),
                  hintText: 'Search Medications by name, brand, or...',
                  hintStyle: WidgetStateProperty.all(
                    AppTextStyles.interP14R.copyWith(color: theme.neutral.secondaryText),
                  ),
                  onChanged: (value) => ref.read(inventoryProvider.notifier).updateSearch(value),
                  backgroundColor: WidgetStateProperty.all(theme.neutral.bgTint),
                  elevation: WidgetStateProperty.all(0),
                  side: WidgetStateProperty.all(BorderSide(color: theme.neutral.border.withOpacity(0.3))),
                ),
              ),
              SizedBox(width: context.figmaWidth(8)),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const InventoryFilterBottomSheet(),
                  );
                },
                icon: SvgPicture.asset(AppIcons.filter, width: 24, height: 24),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.figmaWidth(16), vertical: context.figmaHeight(8)),
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _toggleSortOverlay,
                  child: Row(
                    children: [
                      Icon(Icons.sort, size: 18, color: theme.neutral.secondaryText),
                      SizedBox(width: 4),
                      Text(
                        sortBy.name.substring(0, 1).toUpperCase() + sortBy.name.substring(1),
                        style: AppTextStyles.interP14M.copyWith(color: theme.neutral.primaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
