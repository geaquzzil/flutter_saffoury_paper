import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/encyptions/compressions.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/debouncer.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchWidgetWebComponent extends StatelessWidget {
  final ValueNotifier<double> scrollvalueNofifier;
  Function(String v)? onSearchTextChanged;
  SearchWidgetWebComponent({
    super.key,
    this.onSearchTextChanged,
    required this.scrollvalueNofifier,
  });
  Widget getSearchTitleEditable(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: (value) async {
        if (value.isEmpty) return;
        debugPrint("onSubmitted $value");
        onSearchTextChanged?.call(value);
      },
      decoration: InputDecoration.collapsed(
        hintText: AppLocalizations.of(context)?.search,
      ),
    );
  }

  Widget? getLeadingWidget(BuildContext context) {
    // if (SizeConfig.isLargeScreen(context)) return null;
    Widget icon = IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        context.read<DrawerMenuControllerProvider>().controlStartDrawerMenu();
      },
    );

    return ValueListenableBuilder<double>(
      valueListenable: scrollvalueNofifier,
      builder: (context, value, child) {
        return AnimatedScale(
          duration: const Duration(milliseconds: 275),
          scale: value > 100 ? 1 : 0,
          child: icon,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: kDefaultPadding / 2,
        left: kDefaultPadding / 2,
        right: kDefaultPadding / 2,
      ),
      child: CardCorner(
        // elevation: 3,
        // color: Theme.of(context).colorScheme.primary,
        child: ListTile(
          leading: getLeadingWidget(context),
          title: getSearchTitleEditable(context),
          trailing: Wrap(
            children: [
              // const Spacer(),
              ValueListenableBuilder<double>(
                valueListenable: scrollvalueNofifier,
                builder: (context, value, child) {
                  return AnimatedScale(
                    duration: const Duration(milliseconds: 275),
                    scale: value > 100 ? 1 : 0,
                    child: CartIconWidget(
                      onPressed: () {
                        context
                            .read<DrawerMenuControllerProvider>()
                            .controlEndDrawerMenu();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () async {
                  await ProductWebPage.showFilterDialog(
                    context,
                    context
                        .read<AuthProvider<AuthUser>>()
                        .getWebCategories()[0]
                        .getNewInstance(),
                  ).then((value) {
                    if (value == null) return;
                    String compressed = Compression.compress(value);
                    debugPrint("Compressing $compressed");
                    context.goNamed(
                      indexWebOurProducts,
                      queryParameters: {"filter": Compression.compress(value)},
                    );
                    // context.read<DrawerMenuControllerProvider>().changeWithFilterable(context, v);
                  });
                },
                icon: const Icon(Icons.filter_alt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchWidgetComponent extends StatefulWidget {
  String heroTag;
  ViewAbstract viewAbstract;
  Function(String?)? onSearchTextChanged;
  ValueNotifier<String?>? onSearchTextChangedValueNotifier;
  ValueNotifier<ExpandType>? appBardExpandType;
  final SecoundPaneHelperWithParentValueNotifier? state;
  CurrentScreenSize? currentScreenSize;
  SearchWidgetComponent({
    super.key,
    this.heroTag = "/search",
    this.appBardExpandType,
    this.currentScreenSize,
    required this.viewAbstract,
    this.onSearchTextChangedValueNotifier,
    this.state,
    this.onSearchTextChanged,
  });

  @override
  State<SearchWidgetComponent> createState() => _SearchWidgetComponentState();
}

class _SearchWidgetComponentState extends State<SearchWidgetComponent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;
  bool isEditText = false;
  final Debouncer _debouncer = Debouncer(milliseconds: 200);
  final TextEditingController _textEditingController = TextEditingController();
  late ViewAbstract _viewAbstract;
  final ValueNotifier<String?> _valueNotifierOnTextChange = ValueNotifier(null);
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _animationController.forward();
    isEditText =
        widget.onSearchTextChanged != null ||
        widget.onSearchTextChangedValueNotifier != null;
    _textEditingController.addListener(onTextEditingChanged);
    _viewAbstract = widget.viewAbstract;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchWidgetComponent oldWidget) {
    isEditText =
        widget.onSearchTextChanged != null ||
        widget.onSearchTextChangedValueNotifier != null;
    if (_viewAbstract.runtimeType != widget.viewAbstract.runtimeType) {
      _viewAbstract = widget.viewAbstract;
      _textEditingController.value = const TextEditingValue(text: "");
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.removeListener(onTextEditingChanged);
    _textEditingController.dispose();
    _valueNotifierOnTextChange.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: Cards(
        type: CardType.filled,
        // margin: 2,
        // elevation: 3,
        // color: Theme.of(context).colorScheme.primary,
        child: (hoverd) => ListTile(
          leading: isEditText
              ? const Icon(Icons.search)
              : getLeadingWidget(context),
          onTap: isEditText
              ? null
              : () => context.goNamed(
                  searchRouteName,
                  queryParameters: {"query": "q"},
                  pathParameters: {
                    "tableName": context
                        .read<DrawerMenuControllerProvider>()
                        .getObjectCastViewAbstract
                        .getTableNameApi()!,
                  },
                ),
          title: isEditText
              ? getSearchTitleEditable()
              : getSearchTitleClickable(),
          trailing: isEditText
              ? getTrailingLargeScreen()
              : CartIconWidget(
                  onPressed: () {
                    context
                        .read<DrawerMenuControllerProvider>()
                        .controlEndDrawerMenu();
                  },
                ),
        ),
      ),
    );
  }

  Widget getSearchTitleEditable() {
    return TextField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: _textEditingController,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) async {
        debugPrint("onSubmitted $value");
        callDebouncer(value);
      },
      decoration: InputDecoration.collapsed(
        border: InputBorder.none,

        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        hintText: getSearchHint(widget.viewAbstract),
        // focusColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
    );
  }

  void callDebouncer(String? query) {
    _debouncer.run(() async {
      widget.onSearchTextChanged?.call(query);
      widget.onSearchTextChangedValueNotifier?.value = query;
    });
  }

  String getSearchHint(ViewAbstract value) {
    return AppLocalizations.of(
      context,
    )!.searchInFormat(value.getMainHeaderLabelTextOnly(context));
  }

  Widget getSearchTitleClickable() {
    return Text(getSearchHint(_viewAbstract));
    return Selector<DrawerMenuControllerProvider, ViewAbstract>(
      builder: (context, value, child) {
        return Text(
          getSearchHint(value),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      },
      selector: (p0, p1) => p1.getObjectCastViewAbstract,
    );
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  // Widget? getLeadingWidget() {
  //   // if (SizeConfig.isLargeScreen(context)) return null;
  //   return IconButton(
  //     icon: AnimatedIcon(
  //       icon: AnimatedIcons.arrow_menu,
  //       progress: _animationController,
  //     ),
  //     onPressed: () {
  //       context.read<DrawerMenuControllerProvider>().controlStartDrawerMenu();
  //     },
  //   );
  // }

  Widget? getLeadingWidget(BuildContext context) {
    // if (SizeConfig.isLargeScreen(context)) return null;
    Widget icon = IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.arrow_menu,
        progress: _animationController,
      ),
      onPressed: () {
        context.read<DrawerMenuControllerProvider>().controlStartDrawerMenu();
      },
    );
    if (widget.appBardExpandType == null) {
      return icon;
    } else {
      return ValueListenableBuilder<ExpandType>(
        valueListenable: widget.appBardExpandType!,
        builder: (context, value, child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: value == ExpandType.CLOSED ? 1 : 0,
            child: icon,
          );
        },
      );
    }
  }

  OnHoverWidget buildColapsedIcon(
    BuildContext context,
    IconData data,
    VoidCallback? onPress,
  ) {
    return OnHoverWidget(
      scale: false,
      builder: (onHover) {
        return IconButton(
          // padding: EdgeInsets.all(4),
          onPressed: onPress,
          iconSize: 25,
          icon: Icon(data),
          color: onHover
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary,
        );
      },
    );
  }

  Widget? getTrailinAddOn(String? text) {
    return _viewAbstract.getSearchTraling(
      context,
      state: widget.state,
      text: text,
    );
  }

  Widget getTrailingLargeScreen() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: _valueNotifierOnTextChange,
          builder: (context, value, w) {
            Widget? w = getTrailinAddOn(value);
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: w == null ? 0 : 1,
              child: AnimatedScale(
                duration: const Duration(microseconds: 250),
                scale: w == null ? 0 : 1,
                child: w,
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: _valueNotifierOnTextChange,
          builder: (context, value, w) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: value == null ? 0 : 1,
              child: AnimatedScale(
                duration: const Duration(microseconds: 250),
                scale: value == null ? 0 : 1,
                child: IconButton(
                  onPressed: () {
                    _textEditingController.clear();
                    callDebouncer(null);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            );
          },
        ),

        // Text("s"),
        CartIconWidget(
          onPressed: () {
            context.read<DrawerMenuControllerProvider>().controlEndDrawerMenu();
          },
        ),
      ],
    );
  }

  void onTextEditingChanged() {
    String value = _textEditingController.value.text;
    _valueNotifierOnTextChange.value = (value.isEmpty || value == "")
        ? null
        : value;
  }
}
