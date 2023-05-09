import 'package:flutter/material.dart';
import 'package:robot_chat_flutter/model/message.dart';

class MessageCard extends StatefulWidget {
  final Message msg;

  const MessageCard({required this.msg, super.key});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        textDirection:
            widget.msg.isFromUser ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
                width: 1.5,
              ),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                  widget.msg.isFromUser
                      ? 'images/user_pic.jpg'
                      : 'images/robot_pic.jpeg',
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      widget.msg.message,
                      style: const TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.none,
                          color: Colors.black),
                      maxLines: isExpanded ? null : 1,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageInput extends StatefulWidget {
  final Function(String) onSendClick;
  final FocusNode focusNode;

  const MessageInput(
      {super.key, required this.onSendClick, required this.focusNode});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFCCCCCC),
          ),
          constraints: const BoxConstraints(
            minHeight: 50,
            maxHeight: 150,
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    focusNode: widget.focusNode,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      _onClickSend(value);
                    },
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      hintText: 'Type your message here',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _onClickSend(_textEditingController.text);
                },
                child: const Text('Send'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    ));
  }

  void _onClickSend(String text) {
    widget.onSendClick(text);
    _textEditingController.clear();
    widget.focusNode.unfocus();
  }
}

class MessageList extends StatefulWidget {
  final List<Message> messages;
  final ScrollController scrollController;

  const MessageList(
      {super.key, required this.messages, required this.scrollController});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      controller: widget.scrollController,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        return MessageCard(msg: widget.messages[index]);
      },
    );
  }
}
