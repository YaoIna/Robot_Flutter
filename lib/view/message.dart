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

  const MessageInput({super.key, required this.onSendClick});

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
                    maxLines: null,
                    onSubmitted: (value) {
                      widget.onSendClick(value);
                      _textEditingController.clear();
                      FocusScope.of(context).unfocus();
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
                  widget.onSendClick(_textEditingController.text);
                  _textEditingController.clear();
                  FocusScope.of(context).unfocus();
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
}

class MessageList extends StatefulWidget {
  final List<Message> messages;

  const MessageList({super.key, required this.messages});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        return MessageCard(msg: widget.messages[index]);
      },
    );
  }
}
