import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class VideoPLayerController extends ChangeNotifier {
  dynamic current;
  bool _hide = true;
  FijkPlayer _player = FijkPlayer();
  FijkPlayer video = FijkPlayer();
  FijkPlayer get controller => _player;

  void play(url) async {
    _player.setDataSource(
      url,
      autoPlay: true,
    );

    video.addListener(() async {
      if (video.isPlayable()) await _player.pause();
    });
    await _player.pause();
  }

  bool get showPopUp => !_hide;
  @override
  void dispose() {
    _player.release();
    video.release();
    super.dispose();
  }

  Future<void> changeVideo(url) async {
    if (url != current || _hide) {
      _hide = false;
      current = url;
      await video.reset();
      await video.setDataSource(current, autoPlay: true);
      notifyListeners();
    }
  }

  Future<void> exit() async {
    await video.stop();

    _hide = true;
    notifyListeners();
  }
}
