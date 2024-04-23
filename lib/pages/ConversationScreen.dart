import 'package:billy/providers/AudioPlayerProvider.dart';
import 'package:billy/providers/databaseProvider.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/Message.dart';
import 'package:billy/providers/conversation_provider.dart';
import 'package:billy/components/text_bubble.dart';
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
  }

  Future _speak() async {
    await ttsManager.flutterTts.setVolume(ttsManager.volume);
    await ttsManager.flutterTts.setSpeechRate(ttsManager.rate);
    await ttsManager.flutterTts.setPitch(ttsManager.pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        _stopListening();
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
