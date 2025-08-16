import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_master.dart';
import 'package:flutter_view_controller/new_screens/theme.dart';
import 'package:flutter_view_controller/providers/actions/action_viewabstract_provider.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:provider/provider.dart';

class ListCardItemMasterHorizontal<T extends ViewAbstract>
    extends ListCardItemMaster<T> {
  final double? currentSize;
  final bool hightLightonSelect;
  final bool setDescriptionAtBottom;

  ListCardItemMasterHorizontal({
    required super.object,
    this.setDescriptionAtBottom = false,
    this.hightLightonSelect = false,
    this.currentSize,
    super.state,
    super.stateForToggle,
    super.searchQuery,
    super.isSelectForListTile,
    super.isSelectMoodEnabled,
    super.isSelectForSelection,
    super.onTap,
    super.onLongTap,
    super.title,
    super.subtitle,
    super.traling,
  }) : super(key: GlobalKey());

  @override
  State<StatefulWidget> createState() =>
      _ListCardItemMasterHorizontalState<T, ListCardItemMasterHorizontal<T>>();
}

class _ListCardItemMasterHorizontalState<
  T extends ViewAbstract,
  E extends ListCardItemMasterHorizontal<T>
>
    extends ListCardItemMasterState<T, E> {
  @override
  Widget build(BuildContext context) {
    return HoverImage(
      bottomWidget: widget.setDescriptionAtBottom
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  object.getHorizontalCardMainHeader(context),
                  object.getHorizontalCardSubtitle(context),
                ],
              ),
            )
          : null,
      image: object.getImageUrlAddHost(context) ?? "",
      builder: (isHovered) {
        Widget child = GestureDetector(
          onLongPress: () {
            onLongPress();
          },
          onTap: () {
            onTap();
          },
          child: _getStack(context, isHovered),
        );
        return child;
      },
    );
  }

  Widget _getStack(BuildContext context, bool isHovered) {
    return Stack(
      children: [
        _buildBackground(context, isHovered),
        _buildGradient(context, isHovered),
        _buildTitleAndSubtitle(context, isListTileSelected() || isHovered),
        if (object is CartableProductItemInterface)
          if (object
                  .getCartableProductItemInterface()
                  .getCartableProductQuantity() !=
              0)
            if (_buildCartIcon(isHovered, context) != null)
              _buildCartIcon(isHovered, context)!,
        if (widget.hightLightonSelect)
          Selector<ActionViewAbstractProvider, ViewAbstract?>(
            builder: (context, value, child) {
              bool isLargeScree = isLargeScreen(context);
              bool isSelected =
                  (value?.isEquals(object) ?? false) && isLargeScree;

              debugPrint("WebGride is selected $isSelected");
              return !isSelected
                  ? const Positioned.fill(child: SizedBox())
                  : Positioned.fill(
                      // top: ,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 275),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.surfaceTint.withValues(alpha: .2),
                              // .withValues(alpha:.9),
                              Theme.of(
                                context,
                              ).colorScheme.surfaceTint.withValues(alpha: .9),
                              // .withValues(alpha:.9),
                              // Colors.black.withValues(alpha:0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.6, 0.95],
                          ),
                        ),
                      ),
                    );
            },
            selector: (p0, p1) => p1.getObject,
          ),
      ],
    );
  }

  Positioned? _buildCartIcon(bool isHovered, BuildContext context) {
    debugPrint("buildCart ${widget.currentSize}");
    if (widget.currentSize != null) {
      if (widget.currentSize! < 150) {
        return null;
      }
    }
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 275),
        opacity: isHovered ? 1 : 0,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 275),
          scale: isHovered ? 1 : 0,
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                showCartDialog(context, object as CartableProductItemInterface);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoverBackground(BuildContext context) {
    return Positioned.fill(
      child: object.getImageUrlAddHost(context) == null
          ? Container()
          : HoverImage(image: object.getImageUrlAddHost(context)!),
    );
  }

  Widget _buildBackground(BuildContext context, bool isHoverd) {
    return Positioned.fill(
      child: object.getHeroTag(
        context: context,
        child: Container(
          decoration: getBoxDecoration(context, isHoverd),
          child: object.getImageUrlAddHost(context) == null
              ? object.getCustomImage(context, isGrid: true) ??
                    object.getImageIfNoUrl()
              : null,
        ),
      ),
    );
  }

  BoxDecoration getBoxDecoration(BuildContext context, bool isHoverd) {
    return BoxDecoration(
      image: object.getImageUrlAddHost(context) == null
          ? null
          : DecorationImage(
              image: FastCachedImageProvider(
                object.getImageUrlAddHost(context)!,
              ),
              fit: BoxFit.cover,
            ),
      color: null,
      border: isHoverd || (isListTileSelected())
          ? Border.all(
              width: 2,
              color: isListTileSelected()
                  ? Theme.of(context).colorScheme.onSecondaryContainer
                  : Theme.of(context).highlightColor,
            )
          : null,
      borderRadius: getBorderRedius(),
    );
  }

  BorderRadius getBorderRedius() =>
      const BorderRadius.all(Radius.circular(kBorderRadius));

  Widget _buildGradient(BuildContext context, bool isHoverd) {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 275),
        decoration: BoxDecoration(
          border: isHoverd || isListTileSelected()
              ? Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.secondary,
                )
              : null,
          borderRadius: getBorderRedius(),
          gradient: getLinearGradient(
            context,
            (isSelectedForListTile ?? false) || isHoverd,
          ),
        ),
      ),
    );
  }

  LinearGradient getLinearGradient(BuildContext context, bool isHoverd) {
    List<Color> colors = [];
    List<double> stops = [];
    if (isListTileSelected()) {
      Color color=Theme.of(
                context,
              ).colorScheme.secondaryContainer.withValues(alpha: .7);
      colors = [
        isHoverd
            ? Theme.of(
                context,
              ).colorScheme.secondaryContainer.withValues(alpha: .7)
            : Theme.of(
                context,
              ).colorScheme.secondaryContainer.withValues(alpha: .7),
        isHoverd
            ? Theme.of(
                context,
              ).colorScheme.secondaryContainer.withValues(alpha: .7)
            : Theme.of(
                context,
              ).colorScheme.secondaryContainer.withValues(alpha: .7),
      ];
      stops = [0, 0.99];
    } else {
      if (widget.setDescriptionAtBottom) {
        colors = [
          isHoverd
              ? Colors.black.withValues(alpha: 0.7)
              : Colors.black.withValues(alpha: 0.3),
          !isHoverd
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).scaffoldBackgroundColor,
        ];
        stops = [0, 0.99];
      } else {
        colors = [
          isHoverd ? Colors.black.withValues(alpha: 0.7) : Colors.transparent,
          isHoverd ? Colors.black.withValues(alpha: 0.7) : Colors.transparent,
        ];

        stops = [6, 0.95];
      }
    }
    return LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: stops,
    );
  }

  Widget _buildTitleAndSubtitle(BuildContext context, bool isHoverd) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 275),
        opacity: isHoverd
            ? 1
            : widget.setDescriptionAtBottom
            ? 1
            : 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            object.getHorizontalCardMainHeader(context),
            object.getHorizontalCardSubtitle(context),
          ],
        ),
      ),
    );
  }
}
