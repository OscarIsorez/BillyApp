import 'package:billy/providers/AudioPlayerProvider.dart';
import 'package:billy/providers/databaseProvider.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/Message.dart';
import 'package:billy/providers/conversation_provider.dart';
import 'package:billy/components/text_bubble.dart';
import 'package:billy/tts/ttsState.dart';
import 'package:billy/tts/tts_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required Conversation conversation});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speechToText = SpeechToText();
  // ignore: unused_field
  bool _speechEnabled = false;
  String _lastWords = '';
  late TtsManager ttsManager;

  String? _newVoiceText;

  @override
  void initState() {
    super.initState();
    ttsManager = TtsManager();
    _initSpeech();
    initTts();
  }

  Future _getDefaultEngine() async {
    var engine = await ttsManager.flutterTts.getDefaultEngine;
  }

  Future _getDefaultVoice() async {
    final voices = await ttsManager.flutterTts.getVoices;
    var voice = voices.firstWhere(
        (element) => element['name'] == ttsManager.language,
        orElse: () => voices.first);

    /* Map (2 items)
      0:
      "name" -> "es-us-x-sfb-local"
      key:
      "name"
      value:
      "es-us-x-sfb-local"
      1:
      "locale" -> "es-US"
      key:
      "locale"
      value:
      "es-US" */

    voice = {'name': "es-us-x-sfb-local", 'locale': 'es-US'};
    await ttsManager.flutterTts.setVoice(voice);
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
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() async {
      _lastWords = result.recognizedWords;
      if (_lastWords.isNotEmpty) {
        Provider.of<ConversationProvider>(context, listen: false)
            .addMessage(_lastWords);
        await Provider.of<ConversationProvider>(context, listen: false)
            .fetchResponse();
        Message? _newVoiceText =
            Provider.of<ConversationProvider>(context, listen: false)
                .getLastMessage();
        _onChange(_newVoiceText!.content);
        await _speak();
        _startListening();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          _stopSpeaking();
          _stopListening();
          Provider.of<Database>(context, listen: false).updateConversation(
            Provider.of<ConversationProvider>(context, listen: false)
                .conversation,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
                Provider.of<ConversationProvider>(context, listen: false)
                    .conversation
                    .name)),
        body: Consumer<ConversationProvider>(
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
                  message: chatProvider.messages[index].content,
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
      ),
    );
  }
}
