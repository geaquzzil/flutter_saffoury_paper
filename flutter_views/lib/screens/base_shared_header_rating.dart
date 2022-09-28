import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import '../constants.dart';

class BaseSharedDetailsRating extends StatelessWidget {
  ViewAbstract viewAbstract;
  BaseSharedDetailsRating({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: FormBuilderRatingBar(
           
            name: "name",
            itemSize: 20,
          ),
        ),
        const SizedBox(width: kDefaultPadding / 2),
        Expanded(
          flex: 2,
          child: Text(
            "4.4 (328 reviews)",
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ],
    );
  }
}
