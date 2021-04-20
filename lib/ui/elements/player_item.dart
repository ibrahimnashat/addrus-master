import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class PlayerItem extends StatelessWidget {
  final FijkPlayer controller;
  PlayerItem({@required this.controller});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FijkView(
        player: controller,
        fit: FijkFit.fill,
        color: Colors.white,
        fsFit: FijkFit.fill,
      ),
    );
  }
}
