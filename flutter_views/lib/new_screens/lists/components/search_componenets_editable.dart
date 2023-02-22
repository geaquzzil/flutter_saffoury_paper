import 'package:flutter/material.dart';

import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';

import 'package:flutter_view_controller/utils/debouncer.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SearchWidgetComponentEditable extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  bool trailingIsCart;
  final Debouncer _debouncer = Debouncer(milliseconds: 700);
  ValueNotifier<String>? notiferSearch;
  void Function(String value)? notiferSearchVoid;

  SearchWidgetComponentEditable({
    super.key,
    this.trailingIsCart = false,
    this.notiferSearch,
    this.notiferSearchVoid,
  }) : assert(notiferSearch != null || notiferSearchVoid != null);

  @override
  Widget build(BuildContext context) {
    return _buildSearchBox(context);
  }

  void callDebouncer(String query) {
    _debouncer.run(() async {
      if (notiferSearch != null) {
        notiferSearch!.value = query;
      }
      if (notiferSearchVoid != null) {
        notiferSearchVoid!.call(query);
      }
    });
  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ListTile(
          // tileColor: Colors.transparent,
          leading: const Icon(Icons.search),
          title: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) async {
              debugPrint("onSubmitted $value");
              callDebouncer(value);
            },
            controller: controller,
            decoration: InputDecoration(
                fillColor: Colors.transparent,
                hintText: AppLocalizations.of(context)?.search,
                border: InputBorder.none),
          ),
          trailing: trailingIsCart
              ? CartIconWidget(
                  returnNillIfZero: true,
                  onPressed: () {
                    debugPrint("onPressed cart");
                  },
                )
              : getTrailingWidget()),
    );
  }

  Widget getTrailingWidget() {
    return IconButton(
      icon: const Icon(Icons.cancel),
      onPressed: () {
        controller.clear();
        callDebouncer('');
      },
    );
  }
}
