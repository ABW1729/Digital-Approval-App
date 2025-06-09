import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  TtsService() {
    _tts.setLanguage("hi-IN");
    _tts.setSpeechRate(0.9);
    _tts.setPitch(1.0);
  }

  Future<void> speak(String message) async {
    await _tts.speak(message);
  }
}
