import 'package:dart_openai/openai.dart';
import 'package:robot_chat_flutter/model/env.dart';
import 'package:robot_chat_flutter/viewmodel/robot_bloc.dart';

import '../model/message.dart';
import '../model/ui_state.dart';

class RobotChatViewModel {
  // late ApiKeyRepository _apiKeyRepository;
  OpenAI? _openAI;

  String _apiKey = "";

  String get apiKey => _apiKey;

  final List<OpenAIChatCompletionChoiceMessageModel> _currentMessageList = [];

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

  final ListBloc _listBloc = ListBloc();

  ListBloc get listBloc => _listBloc;

  final UiStateCubit _uiStateCubit = UiStateCubit();

  UiStateCubit get uiStateCubit => _uiStateCubit;

  void sendMessage(String messageContent) {
    if (messageContent.isEmpty) return;
    OpenAI.apiKey = Env.apiKey;
    final openAI = OpenAI.instance;
    if (openAI != null) {
      _listBloc.add(AddMessageEvent(Message(messageContent, Role.user)));
      _chatWithRobot(messageContent, openAI);
    } else {
      _uiStateCubit.updateState(UiError("Please enter your API key"));
    }
  }

  void _chatWithRobot(String messageContent, OpenAI openAI) async {
    try {
      final messageModel = OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user, content: messageContent);
      _currentMessageList.add(messageModel);
      final result = await openAI.chat
          .create(model: "gpt-3.5-turbo", messages: _currentMessageList);
      if (result.choices.isEmpty) return;
      final message = result.choices.first.message;
      _currentMessageList.add(message);
      _listBloc.add(AddMessageEvent(Message(
          message.content,
          message.role == OpenAIChatMessageRole.user
              ? Role.user
              : Role.robot)));
    } on RequestFailedException catch (e) {
      _uiStateCubit.updateState(UiError(e.message));
    }
  }
}
