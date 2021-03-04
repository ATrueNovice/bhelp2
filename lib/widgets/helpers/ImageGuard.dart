import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageGuard {
  Widget imageGuard(image, boxFit) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: CachedNetworkImage(
        alignment: Alignment.center,
        fit: boxFit,
        imageUrl: image,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(
          value: downloadProgress.progress,
          strokeWidth: 2.0,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
