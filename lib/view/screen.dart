import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:robot_chat_flutter/model/ui_state.dart';
import 'package:robot_chat_flutter/view/message.dart';
import 'package:robot_chat_flutter/viewmodel/robot_chat_viewmodel.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RobotChatViewModel(),
        child: Consumer<RobotChatViewModel>(
          builder: (context, viewModel, child) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (viewModel.uiState is UiError) {
                final state = viewModel.uiState as UiError;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            });
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: FooterLayout(
                  footer: KeyboardAttachable(
                      child: MessageInput(onSendClick: viewModel.sendMessage)),
                  child: MessageList(messages: viewModel.messageList),
                ));
          },
        ));
  }
}
