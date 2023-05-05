import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:robot_chat_flutter/view/message.dart';
import 'package:robot_chat_flutter/viewmodel/robot_chat_viewmodel.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RobotChatViewModel(),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: FooterLayout(
              footer: KeyboardAttachable(child: Consumer<RobotChatViewModel>(
                  builder: (context, viewModel, child) {
                return MessageInput(onSendClick: viewModel.sendMessage);
              })),
              child: Consumer<RobotChatViewModel>(
                  builder: (context, viewModel, child) {
                return MessageList(messages: viewModel.messageList);
              }),
            )));
  }
}
