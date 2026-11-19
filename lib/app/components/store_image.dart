import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreImage extends StatelessWidget {
  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;

  const StoreImage({
    super.key,
    required this.source,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  bool get _isNetworkImage {
    final uri = Uri.tryParse(source);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Widget _placeholder(BuildContext context) => Icon(
        Icons.image_not_supported_outlined,
        color: Theme.of(context).hintColor,
        size: 36,
      );

  @override
  Widget build(BuildContext context) {
    final isSvg = source.toLowerCase().endsWith('.svg');
    if (isSvg) {
      return _isNetworkImage
          ? SvgPicture.network(
              source,
              width: width,
              height: height,
              fit: fit,
              placeholderBuilder: (_) => _placeholder(context),
            )
          : SvgPicture.asset(
              source,
              width: width,
              height: height,
              fit: fit,
              placeholderBuilder: (_) => _placeholder(context),
            );
    }

    return _isNetworkImage
        ? Image.network(
            source,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _placeholder(context),
          )
        : Image.asset(
            source,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, __, ___) => _placeholder(context),
          );
  }
}
