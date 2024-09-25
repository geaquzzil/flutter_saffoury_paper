import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/cut_requests.dart';
import 'package:flutter_saffoury_paper/models/invoices/cuts_invoices/sizes_cut_requests.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/extensions.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';

class CutRequestListCard extends StatelessWidget {
  CutRequest item;
  CutRequestListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      // color: Colors.white70,
      elevation: 10,
      child: getCard(context),
    );
    return Container(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      width: double.infinity,
      // decoration: BoxDecoration(
      //     color: Colors.green,
      //     borderRadius: BorderRadius.circular(10),
      //     image: DecorationImage(
      //       opacity: .5,
      //       scale: 2,
      //       image: FastCachedImageProvider(item.getImageUrl(context) ?? "",
      //           scale: 2),
      //       fit: BoxFit.cover,
      //     )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 144,
              height: 300,
              child: Container(
                padding: const EdgeInsets.only(bottom: kDefaultPadding),
                width: double.infinity,
                decoration: BoxDecoration(
                    // color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      opacity: .5,
                      scale: 2,
                      image: FastCachedImageProvider(
                          item.getImageUrl(context) ?? "",
                          scale: 2),
                      fit: BoxFit.cover,
                    )),
              )),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                  color: Colors.cyanAccent,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      "I managed to create the layout above (2 ListTile's). But as you can see, when the title property contains a large text as it is doing in the first (the green) tile, the height of the leading widget is not following as it should. The below code returns a ListTile given a Label which is a class of my own that simply contains text, textcolor and backgroundcolor.",
                      softWrap: true,
                      maxLines: 13,
                      style: TextStyle(),
                    ),
                  ),
                  Icon(Icons.menu),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCard(BuildContext context) {
    return ListTile(
      trailing: getTrailing(context),
      leading: getLeading(context),
      title: (item.products?.getMainHeaderText(context)),
      subtitle: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          item.getWebListTileItemSubtitle(context)!,
          const SizedBox(
            height: 20,
          ),

          // item.getListableList().forEach((item){
          //   return Text("");
          // })
          SliverApiMixinStaticList(
            isSliver: false,
            list: item.getListableList(),
            enableSelection: false,
            hasCustomSeperater: const Divider(),
            hasCustomCardBuilder: (index, size) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  "${index + 1}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                title: (size as SizesCutRequest)
                    .getTitleTextHtml(context, item, withProductType: false),
                subtitle: (size).getQunaityWithSheets(context, item),
              );
            },
          )
          // getPrimaryText(AppLocalizations.of(context)!.details),
          // ...item.getListableInterface().getListableList().map(
          //     (toElement) => ListTile(
          //         // selected: isSelected,
          //         // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
          //         // onTap: onTap,
          //         // onLongPress: onLongTap,
          //         leading: getPrimaryText(
          //             "${item.getListableInterface().getListableList().indexOf(toElement) + 1}",
          //             withPadding: false),
          //         title: (toElement as SizesCutRequest)
          //             .getTitleTextHtml(
          //                 context, item as CutRequest),
          //         trailing: SizedBox(
          //             width: 200,
          //             child: toElement.getQunaityWithSheets(
          //                 context, item))

          //         // leading: toElement.getWebListTileItemLeading(context),
          //         // trailing: object.getCardTrailing(context)
          //         ))

          // ListStaticWidget<ViewAbstract>(
          //     list: item!.getListableInterface().getListableList(),
          //     emptyWidget: const Text("null"),
          //     listItembuilder: (item) => ListCardItemWeb(
          //           object: item,
          //         )),
        ]),
      ),
    );
  }

  Widget getTrailing(BuildContext context) {
    return DateTimeWidget(
      date: item.date!,
    );
  }

  Widget getLeading(BuildContext context) {
    return SizedBox(
      width: 144,
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            item.getIDFormat(context),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          // (item.products?.getMainHeaderText(context))!
        ],
      ),
    );
    return SizedBox(
      width: 144,
      height: 500,
      child: Container(
        // height: 500,
        decoration: BoxDecoration(
            // color: Colors.green,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            image: DecorationImage(
              opacity: .5,
              scale: 2,
              image: FastCachedImageProvider(item.getImageUrl(context) ?? "",
                  scale: 2),
              fit: BoxFit.cover,
            )),
        child: Column(
          children: [
            Text(
              item.getIDFormat(context),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            DateTimeWidget(
              date: item.date!,
            )
          ],
        ),
      ),
    );
  }

  Row get(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 200,
            maxHeight: 300,
            minWidth: 300,
            maxWidth: 300,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                image: DecorationImage(
                  opacity: .1,
                  scale: 2,
                  image: FastCachedImageProvider(
                      item.getImageUrl(context) ?? "",
                      scale: 2),
                  fit: BoxFit.cover,
                )),
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.getIDFormat(context),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    item.products?.getMainHeaderTextOnly(context) ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Text("Requested Quantity",
                      style: Theme.of(context).textTheme.titleSmall!),
                  Text(
                    item.quantity?.toCurrencyFormat(symbol: 'KG') ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Text("Customer",
                      style: Theme.of(context).textTheme.titleSmall!),
                  Text(
                    item.customers?.getMainHeaderTextOnly(context) ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  DateTimeWidget(
                    date: item.date!,
                  )
                ],
              ),
            ),
            // child: Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text(
            //         item.getIDFormat(context),
            //         style: Theme.of(context).textTheme.titleLarge,
            //       ),
            //       Spacer(),
            //       DateTimeWidget(
            //         date: item.date!,
            //       )
            //     ],
            //   ),
            // ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.maxFinite,
                child: Text(
                  AppLocalizations.of(context)!.requestedSizeLabel,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                width: double.maxFinite,
                child: SliverApiMixinStaticList(
                  list: item.getListableList(),
                  hasCustomCardBuilder: (i, c) {
                    return ListTile(
                        // selected: isSelected,
                        // selectedTileColor: Theme.of(context).colorScheme.onSecondary,
                        // onTap: onTap,
                        // onLongPress: onLongTap,
                        leading: getPrimaryText(context, "${i + 1}",
                            withPadding: false),
                        title: (c as SizesCutRequest)
                            .getTitleTextHtml(context, item),
                        trailing: SizedBox(
                            width: 200,
                            child: (c).getQunaityWithSheets(context, item)));
                  },
                  enableSelection: false,
                  isSliver: false,
                  isGridView: false,
                  hasCustomSeperater: Divider(),
                ),
              )
              // Container(
              //   width: double.maxFinite,
              //   child: Text(
              //       '100% Australian Angus grain-fed beef with cheese and pickles.  Served with fries.',
              //       style: Theme.of(context).textTheme.bodyMedium),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  String date;
  DateTimeWidget({required this.date});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(date.toDateTimeOnlyMonthAndDayString()),
        Text(date.toDateTimeOnlyTimeString())
      ],
    );
  }
}
