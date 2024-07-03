import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_screens/cart/cart_description/cart_summary_item.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'cart_descriptopn_header.dart';

class SubRowCartDescription extends StatefulWidget {
  const SubRowCartDescription({super.key});

  @override
  State<SubRowCartDescription> createState() => _SubRowCartDescriptionState();
}

class _SubRowCartDescriptionState extends State<SubRowCartDescription>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  late CartProcessType type = CartProcessType.PROCESS;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: null, end: Colors.green)
        .animate(_animationController);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context, listen: false).addListener(() {
        if (!mounted) return;
        CartProcessType providerType =
            context.read<CartProvider>().getProcessType;
        if (type == providerType) return;
        type = providerType;
        if (type == CartProcessType.CHECKOUT) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear_all)),
          ),
          const CartDescriptionHeader(),
          const Spacer(),
          const CartDescriptionTotals(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding),
            width: double.maxFinite,
            child: ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: _colorTween.value,
                // ),
                onPressed: () {
                  context.read<CartProvider>().checkout(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Text(AppLocalizations.of(context)!.checkout),
                )),
          )
        ],
      ),
    );
  }
}

class CartDescriptionTotals extends StatelessWidget {
  const CartDescriptionTotals({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              children: context
                  .watch<CartProvider>()
                  .getCartableInvoice
                  .getCartableInvoiceSummary(context)
                  .map((e) => CartSummaryItem(
                        title: e.title,
                        description: e.description,
                      ))
                  .toList(),
            )));
  }
}
