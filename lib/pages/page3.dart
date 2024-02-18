import 'package:billy/chat_provider.dart';
import 'package:billy/components/text_bubble.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _initSpeech();
    
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
    setState(() {
      _lastWords = result.recognizedWords;
      if (_lastWords.isNotEmpty) {
        Provider.of<ChatProvider>(context, listen: false)
            .addMessage(_lastWords);
        Provider.of<ChatProvider>(context, listen: false).fetchResponse();
      }

      _startListening();
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
