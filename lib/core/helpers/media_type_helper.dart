import 'package:cached_network_image/cached_network_image.dart';
import 'package:evo_project/core/shared/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';

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
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: Icon(Icons.broken_image, size: 40),
      ),
    );
  }
}
