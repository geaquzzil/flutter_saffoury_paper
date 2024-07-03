import 'package:flutter/material.dart';

class RoundedIconButtonNetwork extends StatelessWidget {
  final double size;

  final GestureTapCallback onTap;
  final String? imageUrl;
  const RoundedIconButtonNetwork({
    super.key,
    this.size = 18,
    required this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return const Text("TODO");
    // return CachedNetworkImage(
    //   imageUrl: imageUrl ?? "",
    //   imageBuilder: (context, image) => Container(
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(size),
    //       color: kWhite,
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black.withOpacity(0.12),
    //           offset: const Offset(0, 1),
    //           blurRadius: 4,
    //         ),
    //       ],
    //     ),
    //     child: CircleAvatar(
    //       radius: size,
    //       backgroundImage: image,
    //     ),
    //   ),
    //   placeholder: (context, url) => const CircularProgressIndicator(),
    //   errorWidget: (context, url, error) => const Icon(Icons.account_circle),
    // );
  }
}
