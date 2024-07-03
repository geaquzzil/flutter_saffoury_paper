import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

class BaseSharedDetailsRating extends StatelessWidget {
  ViewAbstract viewAbstract;
  BaseSharedDetailsRating({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBarIndicator(
          rating: 2.75,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.primary,
          ),
          itemCount: 5,
          itemSize: 15,
          direction: Axis.horizontal,
        ),
        Text(
          "4.4 (328 reviews)",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
