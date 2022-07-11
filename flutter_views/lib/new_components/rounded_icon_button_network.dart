import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class RoundedIconButtonNetwork extends StatelessWidget {
  double size;
   RoundedIconButtonNetwork({
    Key? key,
    this.size = 20,
    required this.onTap,
    required this.imageUrl,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, image) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          color: kWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: size,
          backgroundImage: image,
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
