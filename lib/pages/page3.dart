import 'dart:io' show Platform;

import 'package:billy/chat_provider.dart';
import 'package:billy/components/text_bubble.dart';
import 'package:billy/ttsState.dart';
import 'package:billy/tts_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key, required List<String> allMessages});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  late List<String> _allMessages;
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late TtsManager ttsManager;
  // String? language = 'en-GB-default';
  // String? engine = "com.samsung.SMT";
  // double volume = 0.5;
  // double pitch = 1.0;
  // double rate = 0.5;
  // bool isCurrentLanguageInstalled = false;

  String? _newVoiceText;
  int? _inputLength;

  // TtsState ttsState = TtsState.stopped;

  // get isPlaying => ttsState == TtsState.playing;
  // get isStopped => ttsState == TtsState.stopped;
  // get isPaused => ttsState == TtsState.paused;
  // get isContinued => ttsState == TtsState.continued;

  // bool get isIOS => !kIsWeb && Platform.isIOS;
  // bool get isAndroid => !kIsWeb && Platform.isAndroid;
  // bool get isWindows => !kIsWeb && Platform.isWindows;
  // bool get isWeb => kIsWeb;

  @override
  void initState() {
    super.initState();
    ttsManager = TtsManager();
    _initSpeech();
    initTts();
  }

  initTts() {
    _setAwaitOptions();

    if (ttsManager.isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    ttsManager.flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsManager.ttsState = TtsState.playing;
      });
    });

    if (ttsManager.isAndroid) {
      ttsManager.flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    ttsManager.flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsManager.ttsState = TtsState.stopped;
      });
    });

    ttsManager.flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsManager.ttsState = TtsState.stopped;
      });
    });

    ttsManager.flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsManager.ttsState = TtsState.paused;
      });
    });

    ttsManager.flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsManager.ttsState = TtsState.continued;
      });
    });

    ttsManager.flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsManager.ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async =>
      await ttsManager.flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await ttsManager.flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await ttsManager.flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await ttsManager.flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await ttsManager.flutterTts.setVolume(ttsManager.volume);
    await ttsManager.flutterTts.setSpeechRate(ttsManager.rate);
    await ttsManager.flutterTts.setPitch(ttsManager.pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await ttsManager.flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await ttsManager.flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await ttsManager.flutterTts.stop();
    if (result == 1) setState(() => ttsManager.ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await ttsManager.flutterTts.pause();
    if (result == 1) setState(() => ttsManager.ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    ttsManager.flutterTts.stop();
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  Widget _pitch() {
    return Slider(
      value: ttsManager.pitch,
      onChanged: (newPitch) {
        setState(() => ttsManager.pitch = newPitch);
      },
      min: 0.5,
      max: 2.0,
      divisions: 15,
      label: "Pitch: $ttsManager.pitch",
      activeColor: Colors.red,
    );
  }

  Widget _rate() {
    return Slider(
      value: ttsManager.rate,
      onChanged: (newRate) {
        setState(() => ttsManager.rate = newRate);
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $ttsManager.rate",
      activeColor: Colors.green,
    );
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        if (result.finalResult) {
          _onSpeechResult(result);
        }
      },
    );

    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    print('Result: ${result.recognizedWords}');
    setState(() async {
      _lastWords = result.recognizedWords;
      if (_lastWords.isNotEmpty) {
        Provider.of<ChatProvider>(context, listen: false)
            .addMessage(_lastWords);
        await Provider.of<ChatProvider>(context, listen: false).fetchResponse();
        _newVoiceText =
            Provider.of<ChatProvider>(context, listen: false).getLastMessage();
        print("_newVoiceText" + _newVoiceText!);
        _onChange(_newVoiceText!);
        await _speak();
        _startListening();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Demo'),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
          return ListView.builder(
            controller: _scrollController,
            itemCount: chatProvider.messages.length,
            itemBuilder: (context, index) {
              return TextBubble(
                message: chatProvider.messages[index],
                isSender: index % 2 == 0, // Change this as needed
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
