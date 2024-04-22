import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  String asset = "interface-soft-click-131438.mp3";
  // ignore: unused_field
  bool _isPlaying = false;

  void play() async {
    await player.stop();
    await player.play(AssetSource(asset));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await player.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void stop() async {
    await player.stop();
  }

  void seek(double position) async {
    await player.seek(Duration(milliseconds: position.toInt()));

    notifyListeners();
  }

  void dispose() {
    player.dispose();
    super.dispose();
  }
}
