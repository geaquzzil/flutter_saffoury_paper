import 'package:flutter/material.dart';

class TitleForHorizontalList extends StatelessWidget {
  final String title;
  const TitleForHorizontalList({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
