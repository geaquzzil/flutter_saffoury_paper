import 'package:flutter/material.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_screens/pos/pos_cart_list.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/cart/cart_provider.dart';
import '../cart/cart_description/cart_description.dart';
import 'package:flutter_view_controller/l10n/app_localization.dart';

class POSDescription extends StatefulWidget {
  const POSDescription({super.key});

  @override
  State<POSDescription> createState() => _POSDescriptionState();
}

class _POSDescriptionState extends State<POSDescription>
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

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<CartProvider>(context, listen: false).addListener(() {
    //     CartProcessType providerType =
    //         context.read<CartProvider>().getProcessType;
    //     if (type == providerType) return;
    //     type = providerType;
    //     if (type == CartProcessType.CHECKOUT) {
    //       _animationController.forward();
    //     } else {
    //       _animationController.reverse();
    //     }
    //   });
    // });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.no_summary,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear_all))
                ],
              ),
            ),
            const Expanded(child: POSCartList()),
            const CartDescriptionTotals(),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding),
              width: double.maxFinite,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorTween.value,
                  ),
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
      ),
    );
  }
}
