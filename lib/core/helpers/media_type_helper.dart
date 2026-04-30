import 'package:cached_network_image/cached_network_image.dart';
import 'package:evo_project/core/shared/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

bool isVideo(String url) {
  return url.toLowerCase().endsWith('.mp4');
}

// ignore: unused_element
Widget mediaWidget(String url) {
  if (isVideo(url)) {
    return VideoPlayerWidget(videoUrl: url);
  } else {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          Center(child: SvgPicture.asset('lib/assets/icons/app_logo.svg')),
    );
  }
}
