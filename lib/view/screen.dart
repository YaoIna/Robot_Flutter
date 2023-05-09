import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:robot_chat_flutter/model/message.dart';
import 'package:robot_chat_flutter/model/ui_state.dart';
import 'package:robot_chat_flutter/viewmodel/robot_bloc.dart';
import 'package:robot_chat_flutter/viewmodel/robot_chat_viewmodel.dart';

import 'message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final viewModel = RobotChatViewModel();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => viewModel.listBloc),
          BlocProvider(create: (BuildContext context) => viewModel.uiStateCubit)
        ],
        child: BlocConsumer<UiStateCubit, UiState>(
          listener: (context, state) {
            if (state is UiError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: FooterLayout(
                    footer: KeyboardAttachable(
                        child:
                            MessageInput(onSendClick: viewModel.sendMessage)),
                    child: BlocBuilder<ListBloc, List<Message>>(
                      builder: (context, state) => MessageList(messages: state),
                    )));
          },
        ));
  }
}
