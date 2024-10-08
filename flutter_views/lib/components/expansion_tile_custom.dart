import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/elevated_card.dart';

import '../new_components/cards/clipper_card.dart';

class ExpansionTileEditable extends StatefulWidget {
  ViewAbstract parent;
  String fieldNameFromParent;
  ViewAbstract viewAbstract;

  ViewAbstract? initialValue;
  ExpansionTileEditable(
      {super.key,
      required this.parent,
      required this.fieldNameFromParent,
      required this.viewAbstract,
      this.initialValue});

  @override
  State<ExpansionTileEditable> createState() => ExpansionTileEditableState();
}

class ExpansionTileEditableState extends State<ExpansionTileEditable> {
  // ExpansionTileController controller=ExpansionTileController();
  TextEditingController controller = TextEditingController();
   late ViewAbstract viewAbstract;
  @override
  void initState() {
  viewAbstract= widget.viewAbstract;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool canBeNullable =
        widget.parent.isFieldCanBeNullable(context, widget.fieldNameFromParent);
    // Icons.
    return ElevatedCard(
      child: ExpansionTile(
        // controller: controller,
        collapsedBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Icon(widget.viewAbstract.getMainIconData()),
        // title: FormBuilderTextField(
        //   name: widget.fieldNameFromParent,
        //   decoration: InputDecoration(
        //       isDense: true,
        //       border: InputBorder.none,
        //       hintText:
        //           widget.viewAbstract.getMainHeaderLabelTextOnly(context)),
        // ),

        title: FormBuilderTypeAheadCustom<ViewAbstract>(
            hideOnEmpty: true,
            onTap: () => controller.selection = TextSelection(
                baseOffset: 0, extentOffset: controller.value.text.length),
            enabled: true,
            controller: controller,
            debounceDuration: const Duration(milliseconds: 750),
            // onChangeGetObject: (text) => autoCompleteBySearchQuery
            //     ? viewAbstract.getNewInstance(
            //         searchByAutoCompleteTextInput: text)
            //     : viewAbstract.getParnet == null
            //         ? viewAbstract.getNewInstance()
            //         : viewAbstract.parent!.getMirrorNewInstanceViewAbstract(
            //             viewAbstract.fieldNameFromParent!)
            //   ..setFieldValue(field, text),
            selectionToTextTransformer: (suggestion) {
              debugPrint(
                  "getControllerEditTextViewAbstractAutoComplete suggestions => ${suggestion.searchByAutoCompleteTextInput}");
              debugPrint(
                  "getControllerEditTextViewAbstractAutoComplete suggestions => ${suggestion.isNew()}");
              return autoCompleteBySearchQuery
                  ? suggestion.isNew()
                      ? suggestion.searchByAutoCompleteTextInput ?? ""
                      : suggestion.getMainHeaderTextOnly(context)
                  : getEditControllerText(suggestion.getFieldValue(field));
            },
            // name: viewAbstract.getTag(field),
           
                     decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
              hint:  
                  widget.viewAbstract.getMainHeaderLabelTextOnly(context)),
            maxLength: viewAbstract.getTextInputMaxLength(field),
            textCapitalization: viewAbstract.getTextInputCapitalization(field),
            keyboardType: viewAbstract.getTextInputType(field),
            autovalidateMode: AutovalidateMode.always,
            // onSuggestionSelected: (value) {
            //   if (autoCompleteBySearchQuery) {
            //     onSelected(value);
            //   }
            //   debugPrint(
            //       "getControllerEditTextViewAbstractAutoComplete value=>$value");
            //   onSelected(viewAbstract.copyWithNewSuggestion(value));
            // },
            // onSaved: (newValue) {
            //   if (autoCompleteBySearchQuery) {}

            //   if (viewAbstract.getParnet != null) {
            //     viewAbstract.getParnet!.setFieldValue(
            //         viewAbstract.getFieldNameFromParent!, newValue);
            //   } else {
            //     viewAbstract.setFieldValue(field, newValue);
            //   }
            //   debugPrint(
            //       'getControllerEditTextViewAbstractAutoComplete onSave parent=> ${viewAbstract.parent.runtimeType} field = ${viewAbstract.getFieldNameFromParent}:value=> ${newValue.runtimeType}');
            // },
            hideOnLoading: true,
            loadingBuilder: (context) => const SizedBox(
                width: double.infinity,
                height: 200,
                child: Center(child: CircularProgressIndicator())),
            itemBuilder: (context, continent) {
              return ListTile(
                leading: continent.getCardLeadingCircleAvatar(context),
                title: Text(continent.getCardItemDropdownText(context)),
                subtitle: Text(continent.getCardItemDropdownSubtitle(context)),
              );
            },
            inputFormatters: viewAbstract.getTextInputFormatter(field),
            validator: (value) {
              if (autoCompleteBySearchQuery) {
                if (value?.isNew() ?? true) {
                  return AppLocalizations.of(context)!.errFieldNotSelected(
                      viewAbstract.getMainHeaderLabelTextOnly(context));
                } else {
                  return viewAbstract
                      .getTextInputValidatorOnAutocompleteSelected(
                          context, field, value!);
                }
              }
              return value?.getTextInputValidator(context, field,
                  getEditControllerText(value.getFieldValue(field)));
            },
            suggestionsCallback: (query) {
              if (query.isEmpty) return [];
              if (query.trim().isEmpty) return [];
              if (autoCompleteBySearchQuery) {
                return viewAbstract.search(5, 0, query, context: context)
                    as Future<List<ViewAbstract>>;
                // field: field, searchQuery: query);
              }
              return viewAbstract.searchViewAbstractByTextInputViewAbstract(
                  field: field, searchQuery: query, context: context);
            }),
        trailing: (canBeNullable)
            ? IconButton(
                icon: const Icon(Icons.minimize_rounded),
                onPressed: () {},
                color: Theme.of(context).colorScheme.error,
              )
            : null,
        children: const [
          Text("dsad"),
          // Text("dsad"),
          // Text("dsad"),
        ],
      ),
    );
  }
}

class ExpansionTileCustom extends StatefulWidget {
  Widget? title;
  Widget? leading;
  Widget? subtitle;
  Widget? trailing;
  bool? hasError;
  bool? isEnabled;
  bool initiallyExpanded;
  bool wrapWithCardOrOutlineCard;
  bool useLeadingOutSideCard;
  List<Widget> children;
  bool padding;
  bool Function()? canExpand;
  bool isDeleteButtonClicked;
  void Function()? onTap;
  ExpansionTileCustom(
      {super.key,
      this.title,
      this.leading,
      this.subtitle,
      this.trailing,
      this.isDeleteButtonClicked = false,
      this.useLeadingOutSideCard = true,
      this.padding = true,
      this.wrapWithCardOrOutlineCard = true,
      required this.children,
      this.initiallyExpanded = false,
      this.isEnabled = true,
      this.hasError,
      this.canExpand});

  @override
  State<ExpansionTileCustom> createState() => EditSubViewAbstractHeaderState();
}

class EditSubViewAbstractHeaderState extends State<ExpansionTileCustom>
    with SingleTickerProviderStateMixin {
  final ColorTween _borderColorTween = ColorTween();
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: .85);
  late EdgeInsets childrenPadding;
  late bool hasError;
  final ColorTween _iconColorTween = ColorTween();
  late Animation<double> _iconTurns;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _iconColor;
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    debugPrint("initState ExpanstionTileCustom ");
    super.initState();

    childrenPadding = EdgeInsets.all(widget.padding ? kDefaultPadding : 0);
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    hasError = widget.hasError ?? false;
    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      if (!canExpand(context)) {
        _controller.value = 0.0;
      } else {
        _controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExpansionTileCustom oldWidget) {
    debugPrint("didUpdateWidget ExpanstionTileCustom ");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    debugPrint("didChangeDependencies ExpanstionTileCustom ");
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    _borderColorTween.end = theme.dividerColor;
    _iconColorTween
      ..begin =
          expansionTileTheme.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = expansionTileTheme.iconColor ?? colorScheme.primary;
    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        widget.initiallyExpanded;
    hasError = widget.hasError ?? false;
    if (_isExpanded) {
      if (!canExpand(context)) {
        _controller.value = 0.0;
      } else {
        _controller.value = 1.0;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: childrenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: result,
    );
  }

  void collapsedOnlyIfExpanded() {
    if (!_isExpanded) {
      if (!hasError) return;
      setState(() {
        hasError = false;
      });
    }
    setState(() {
      _isExpanded = false;
      hasError = false;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
  }

  void setError(bool hasError) {
    setState(() {
      this.hasError = hasError;
    });
  }

  void manualExpand(bool expand, {bool? removeError}) {
    setState(() {
      _isExpanded = expand;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
  }

  bool canExpand(BuildContext context) {
    if (widget.canExpand == null) {
      return true;
    }
    if (widget.canExpand!()) {
      if (widget.isDeleteButtonClicked) return false;
      return true;
    }
    return false;
  }

  void _handleTap(BuildContext context) {
    if (!canExpand(context)) return;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });

    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final Color borderSideColor = _isExpanded
        ? Theme.of(context).colorScheme.primary
        : Colors.transparent;
    if (widget.useLeadingOutSideCard) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: widget.leading,
        title: ClippedCard(
          wrapWithCardOrOutlineCard: widget.wrapWithCardOrOutlineCard,
          borderSide: BorderSideColor.START,
          color: (hasError)
              ? Theme.of(context).colorScheme.error
              : borderSideColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTileTheme.merge(
                iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
                textColor: _iconColor.value,
                child: Focus(
                  descendantsAreFocusable: false,
                  canRequestFocus: false,
                  child: ListTile(
                      onTap: () => _handleTap(context),
                      // contentPadding: expansionTileTheme.tilePadding,
                      // leading: widget.leading,
                      title: widget.title,
                      subtitle: widget.subtitle,
                      trailing: widget.trailing ?? _buildIcon(context)),
                ),
              ),
              if (_isExpanded) const Divider(),
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return ClippedCard(
        wrapWithCardOrOutlineCard: widget.wrapWithCardOrOutlineCard,
        borderSide: BorderSideColor.START,
        color:
            (hasError) ? Theme.of(context).colorScheme.error : borderSideColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTileTheme.merge(
              iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
              textColor: _iconColor.value,
              child: ListTile(
                  onTap: () => _handleTap(context),
                  // contentPadding: expansionTileTheme.tilePadding,
                  leading: widget.leading,
                  title: widget.title,
                  subtitle: widget.subtitle,
                  trailing: widget.trailing ?? _buildIcon(context)),
            ),
            if (_isExpanded) const Divider(),
            ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
          ],
        ),
      );
    }
  }
}
