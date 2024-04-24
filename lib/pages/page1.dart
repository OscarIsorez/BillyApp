import 'package:billy/providers/AudioPlayerProvider.dart';
import 'package:billy/providers/conversation_provider.dart';
import 'package:billy/providers/databaseProvider.dart';
import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/ConversationType.dart';
import 'package:billy/templates/Message.dart';
import 'package:billy/tts/ttsState.dart';
import 'package:billy/tts/tts_manager.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Page1 extends StatefulWidget {
  Page1({Key? key})
      : super(key: key); // Add a named 'key' parameter to the constructor

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final player = AudioPlayer();
  double _width = 200;
  double _height = 200;
  double _outerWidth = 220;
  double _outerHeight = 220;
  bool _isAnimating = false;
  StreamController<bool> _streamController = StreamController<bool>();
  TextEditingController conversationNameController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  late TtsManager ttsManager;
  String? _newVoiceText;

  @override
  void initState() {
    super.initState();
    ttsManager = TtsManager();
    _initSpeech();
    initTts();
  }

//  --------------------------------- TTS AND STT---------------------------------
  Future _getDefaultEngine() async {
    var engine = await ttsManager.flutterTts.getDefaultEngine;
  }

  Future _getDefaultVoice() async {
    final voices = await ttsManager.flutterTts.getVoices;
    var voice = voices.firstWhere(
        (element) => element['name'] == ttsManager.language,
        orElse: () => voices.first);

    // voice = {'name': "es-us-x-sfb-local", 'locale': 'es-US'};
    // await ttsManager.flutterTts.setVoice(voice);
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

  initTts() {
    _setAwaitOptions();

    if (ttsManager.isAndroid) {
      _getDefaultEngine();

      _getDefaultVoice();
    }

    ttsManager.flutterTts.setStartHandler(() {
      if (mounted) {
        setState(() {
          ttsManager.ttsState = TtsState.playing;
        });
      }
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

  Future _speak() async {
    _stopListening();
    await ttsManager.flutterTts.setVolume(ttsManager.volume);
    await ttsManager.flutterTts.setSpeechRate(ttsManager.rate);
    await ttsManager.flutterTts.setPitch(ttsManager.pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await ttsManager.flutterTts.speak(_newVoiceText!);
      }
    }
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  _stopSpeaking() async {
    await ttsManager.flutterTts.stop();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    Provider.of<AudioPlayerProvider>(context, listen: false).play();
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        if (result.finalResult) {
          _onSpeechResult(result);
        }
      },
    );

    if (mounted) setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() async {
      if (result.recognizedWords.isNotEmpty) {
        Provider.of<ConversationProvider>(context, listen: false)
            .addMessage(result.recognizedWords);
        await Provider.of<ConversationProvider>(context, listen: false)
            .fetchResponse();
        Message? _newVoiceText =
            Provider.of<ConversationProvider>(context, listen: false)
                .getLastMessage();
        _onChange(_newVoiceText!.content);
        await _speak();
      }
    });
  }

  // --------------------------------- BUILD---------------------------------

  @override
  void dispose() {
    _isAnimating = false;
    _streamController.add(_isAnimating);
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            _isAnimating = !_isAnimating;

            _streamController.add(_isAnimating);

            if (_isAnimating) {
              Provider.of<ConversationProvider>(context, listen: false)
                  .setConversation(Conversation(
                name: 'Temp ConversationName',
                theme: ConvTheme(type: ConversationType.noTheme),
                messages: [],
              ));
            }

            while (_isAnimating) {
              setState(() {
                _width = 220;
                _height = 220;
                _outerWidth = 240;
                _outerHeight = 240;
              });

              if (!_speechToText.isListening &&
                  !ttsManager.isPlaying &&
                  _isAnimating) {
                _startListening();
              }

              await Future.delayed(const Duration(milliseconds: 600));
              if (!_isAnimating) {
                _stopListening();
                _stopSpeaking();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Conversation Name'),
                      content: TextField(
                        controller: conversationNameController,
                        decoration: const InputDecoration(
                          hintText: "Conversation Name",
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<ConversationProvider>(context,
                                    listen: false)
                                .conversation
                                .setName(conversationNameController.text);
                            Provider.of<Database>(context, listen: false)
                                .addConv(
                              Provider.of<ConversationProvider>(context,
                                      listen: false)
                                  .conversation,
                            );
                            conversationNameController.clear();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              }

              setState(() {
                _width = 200;
                _height = 200;
                _outerWidth = 220;
                _outerHeight = 220;
              });
              await Future.delayed(const Duration(milliseconds: 600));
            }
            // if () {
            await _stopListening();
            await _stopSpeaking();
          },
          child: StreamBuilder<bool>(
              stream: _streamController.stream,
              initialData: false,
              builder: (context, snapshot) {
                return AnimatedContainer(
                  width: _outerWidth,
                  height: _outerHeight,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: AnimatedContainer(
                      width: _width,
                      height: _height,
                      decoration: BoxDecoration(
                        // rouge, il faut parler , bleu il faut écouter
                        color: _speechToText.isNotListening
                            ? Colors.blue
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                      duration: const Duration(seconds: 1),
                      child: const Center(
                        child: Text(
                          "Billy",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
