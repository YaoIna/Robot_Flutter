import 'package:dart_openai/openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:robot_chat_flutter/model/env.dart';

import '../model/message.dart';
import '../model/ui_state.dart';

class RobotChatViewModel with ChangeNotifier {
  // late ApiKeyRepository _apiKeyRepository;
  OpenAI? _openAI;

  String _apiKey = "";

  String get apiKey => _apiKey;

  final List<Message> _messageList = [];

  List<Message> get messageList => _messageList;

  UiState _uiState = Initial();

  UiState get uiState => _uiState;

  // RobotChatViewModel(ApiKeyRepository apiKeyRepository) {
  //   _apiKeyRepository = apiKeyRepository;
  //   _apiKeyRepository.getApi().listen((event) {
  //     _notifyChange(() {
  //       _apiKey = event;
  //     });
  //     if (event.isEmpty) {
  //       _openAI = null;
  //     } else {
  //       OpenAI.apiKey = event;
  //       _openAI = OpenAI.instance;
  //     }
  //   });
  // }

  void sendMessage(String messageContent) {
    if (messageContent.isEmpty) return;
    OpenAI.apiKey = Env.apiKey;
    final openAI = OpenAI.instance;
    if (openAI != null) {
      _notifyChange(() {
        _messageList.insert(0, Message(messageContent, Role.user));
        _chatWithRobot(messageContent, openAI);
      });
    } else {
      _notifyChange(() {
        _uiState = Error("Please enter your API key");
      });
    }
  }

  void _chatWithRobot(String messageContent, OpenAI openAI) async {
    try {
      final result =
          await openAI.chat.create(model: "gpt-3.5-turbo", messages: [
        OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user, content: messageContent)
      ]);
      if (result.choices.isEmpty) return;
      final message = result.choices.first.message;
      _notifyChange(() {
        _messageList.insert(
            0,
            Message(
                message.content,
                message.role == OpenAIChatMessageRole.user
                    ? Role.user
                    : Role.robot));
      });
    } on RequestFailedException catch (e) {
      _notifyChange(() {
        _uiState = Error(e.message);
      });
    }
  }

  void _notifyChange(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}
