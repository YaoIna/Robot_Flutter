import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:robot_chat_flutter/model/message.dart';
import 'package:robot_chat_flutter/model/ui_state.dart';
import 'package:robot_chat_flutter/viewmodel/robot_bloc.dart';
import 'package:robot_chat_flutter/viewmodel/robot_chat_viewmodel.dart';

import 'message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final _viewModel = RobotChatViewModel();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (BuildContext context) => _viewModel.listBloc),
            BlocProvider(
                create: (BuildContext context) => _viewModel.uiStateCubit),
            BlocProvider(
                create: (BuildContext context) => _viewModel.scrollCommandCubit)
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
                          child: MessageInput(
                              onSendClick: _viewModel.sendMessage,
                              focusNode: _focusNode)),
                      child: BlocBuilder<ListBloc, List<Message>>(
                          builder: (context, list) {
                        final scrollController = ScrollController();
                        return BlocListener<ScrollToTopCubit, int>(
                          listener: (context, command) {
                            if (command != 0) {
                              scrollController.animateTo(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            }
                          },
                          child: MessageList(
                            messages: list,
                            scrollController: scrollController,
                          ),
                        );
                      })));
            },
          )),
    );
  }
}
